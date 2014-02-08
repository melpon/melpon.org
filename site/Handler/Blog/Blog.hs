module Handler.Blog.Blog
  ( Blog(..)
  , recentBlogs
  , taggedBlogs
  , urlBlog
  , allTags
  , allBlogs
  , sortedBlogs
  ) where

import Import
import qualified Data.Text                              as T
import qualified Data.Function                          as Func
import qualified Data.List                              as List

import Prelude (head)

import Modules.DateTime (DateTime, strptime)

data Blog = Blog
  { blogDateTime :: DateTime
  , blogTags :: [T.Text]
  , blogURL :: T.Text
  , blogTitle :: T.Text
  , blogWidgetFile :: FilePath
  }

strptime' :: String -> DateTime
strptime' string = strptime "%Y-%m-%d %H:%M:%S" string

allBlogs :: [Blog]
allBlogs =
  [ Blog
      (strptime' "2014-01-25 03:28:00")
      ["Haskell", "Yesod"]
      "new-blog"
      "新しいブログ作りました"
      "templates/blog/new-blog.hamlet"
  , Blog
      (strptime' "2014-01-26 11:21:00")
      ["C++", "Cocos2d-x"]
      "cocos2dx-vector-leak"
      "Cocos2d-x 3.0 beta の Vector がリークする"
      "templates/blog/cocos2dx-vector-leak.hamlet"
  , Blog
      (strptime' "2014-01-28 14:13:00")
      ["C++", "Cocos2d-x"]
      "cocos2dx-create-func"
      "Cocos2d-x の CREATE_FUNC をマシな実装にした"
      "templates/blog/cocos2dx-create-func.hamlet"
  , Blog
      (strptime' "2014-01-30 23:45:00")
      ["Haskell", "Yesod"]
      "put-rss"
      "RSS を配信しました"
      "templates/blog/put-rss.hamlet"
  , Blog
      (strptime' "2014-02-02 04:42:00")
      ["iOS", "In-App Purchase"]
      "ios-consumable-in-app-purchase"
      "iOSで消費型プロダクトのアプリ内課金を実装する際の注意点"
      "templates/blog/ios-consumable-in-app-purchase.hamlet"
  ]

sortBlog :: [Blog] -> [Blog]
sortBlog = List.sortBy ((flip compare) `Func.on` blogDateTime)

sortedBlogs :: [Blog]
sortedBlogs = sortBlog allBlogs

recentBlogs :: [Blog]
recentBlogs = take 5 $ sortBlog allBlogs

taggedBlogs :: T.Text -> [Blog]
taggedBlogs tag = take 5 $ sortBlog $ filter (any (tag==) . blogTags) allBlogs

urlBlog :: T.Text -> Blog
urlBlog url = maybe (error "url Not Found") id $ List.find ((url==) . blogURL) allBlogs

allTags :: [T.Text]
allTags = List.nub $ concat $ map blogTags allBlogs
