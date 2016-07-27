//
//  String+Extension.swift
//


import UIKit

extension String
{
    /// 快速返回一个文档目录路径
    func docDir() -> String
    {
        let docPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        return (docPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 快速返回一个缓存目录的路径
    func cacheDir() -> String
    {
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        return (cachePath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 快速返回一个临时目录的路径
    func tmpDir() -> String
    {
        let tmpPath = NSTemporaryDirectory()
        return (tmpPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
}

