--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "favicon.ico" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["index.md", "pages/links.md", "pages/notes.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/site.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/site.html" postCtx
            >>= relativizeUrls

    create ["pages/archive.html"] $ do
        route idRoute
        compile $ do
            let archiveCtx =
                    field "posts" (\_ -> postList recentFirst) `mappend`
                    constField "title" "Archive"              `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/site.html" archiveCtx
                >>= relativizeUrls


    match "pages/blog.html" $ do
        route idRoute
        compile $ do
            let indexCtx = field "posts" $ \_ ->
                                postList $ fmap (take 3) . recentFirst

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/site.html" postCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext


--------------------------------------------------------------------------------
postList :: ([Item String] -> Compiler [Item String]) -> Compiler String
postList sortFilter = do
    posts   <- sortFilter =<< loadAll "posts/*"
    itemTpl <- loadBody "templates/post-item.html"
    list    <- applyTemplateList itemTpl postCtx posts
    return list
