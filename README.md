# GETCache

GET缓存
----------------
    请求的缓存策略使用 NSURLRequestReloadIgnoringCacheData，忽略本地缓存
    服务器响应结束后，要记录 Etag，服务器内容和本地缓存对比是否变化的重要依据
    在发送请求时，设置 If-None-Match，并且传入 Etag
    连接结束后，要判断响应头的状态码，如果是 304，说明本地缓存内容没有发生变化  
    
    
-----------------
iOS 5.0开始，支持磁盘缓存，但仅支持 HTTP
iOS 6.0开始，支持 HTTPS 缓存
AFNetworking 的作者 Mattt说：无数开发者尝试自己做一个简陋而脆弱的系统来实现网络缓存的功能，殊不知 NSURLCache 只要两行代码就能搞定且好上 100 倍
