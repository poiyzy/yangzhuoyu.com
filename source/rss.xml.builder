# -*- coding: utf-8 -*-
xml.instruct!
xml.rss "xmlns:atom" => "http://www.w3.org/2005/Atom", "version" => "2.0" do
  xml.channel do
    xml.id "http://yangzhuoyu.com"
    xml.title "Roy's Blog"
    xml.link "http://yangzhuoyu.com"
    xml.language "zh-cn"
    xml.copyright "&#x2117; &amp; &#xA9; 2013 Roy Young"
    xml.link "href" => "http://yangzhuoyu.com"
    xml.link "href" => "http://yangzhuoyu.com/rss.xml", "rel" => "self"
    xml.updated blog.articles.first.date.to_time.iso8601
    xml.lastBuildDate blog.articles.first.date.to_time.iso8601
    xml.pubDate blog.articles.first.date.to_time.iso8601
    xml.description "Roy's blog"
    xml.author { xml.name "Roy Young" }

    blog.articles.each do |article|
      xml.item do
        xml.title article.title
        xml.link "http://yangzhuoyu.com#{article.url}"
        xml.description article.body, "type" => "html"
        xml.guid "tag:yangzhuoyu.com,article.url"
        xml.pubDate article.date.to_time.iso8601
        xml.category article.tags.join(', ')
      end
    end
  end
end
