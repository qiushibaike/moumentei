<?xml version='1.0' encoding='UTF-8'?>
<!-- Style RSS so that it is readable. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:msdndomain="http://msdn.microsoft.com/aboutmsdn/rss/domains" version="1.0">
<xsl:template match='/rss'>

 <html>
 <head>
 <title><xsl:value-of select='channel/title'/>（Web Feed）</title>
 <style>
.ph0 {text-decoration: none; color: White; cursor: pointer; cursor: hand;}
.ph1 {text-decoration: underline; color: White; cursor: pointer; cursor: hand;}
.ph2 {vertical-align:middle;}
.ph3 {margin-left:6px;}
body { margin-top:10px; margin-bottom:25px; text-align:center; font-family:Verdana,Simsun; font-size: 9pt; line-height: 1.45em; }
#block { margin:0px auto; width:600px; text-align:left; }
p { padding-top: 0px; margin-top: 0px; }
td { font-family:Verdana,Simsun; font-size: 9pt; line-height: 1.45em; }
h1 { font-size: 10.5pt; padding-bottom: 0px; margin-bottom: 0px; }
h2 { font-size: 9pt; margin-bottom: 0px; }
img { border: none; margin: 0 8px 0 0; }
.text { margin: 0px; }
</style>
<xsl:element name="script">
<xsl:attribute name="type">text/javascript</xsl:attribute>
<xsl:attribute name="src">http://www.qiushibaike.com/xsl_mop-up.js</xsl:attribute>
</xsl:element>					
 </head>

 <body onload="go_decoding();">
 <div id="cometestme" style="display:none;"><xsl:text disable-output-escaping="yes" >&amp;amp;</xsl:text></div>
 <div id='block'>
 <h1><xsl:value-of select='channel/title'/>（Web Feed）</h1>
 <p>通过订阅此Web Feed，您可以在任何Web Feed阅读器或聚合器预览对此空间所作的更新。Web Feed允许您订阅多个源，并自动将信息组合到一个列表中。 您可以快速浏览列表，而不用访问每个网站，就可以搜索您感兴趣的最新信息。
 <br/><br/>如果下面列表中有您正在使用的聚合器，请直接点击进行订阅。</p>
<a href="http://www.bloglines.com/sub/http://www.qiushibaike.com/xml.rss"><img src="http://www.bloglines.com/images/sub_modern5.gif" alt="订阅到Bloglines"/></a>
<a href="http://www.potu.com/sub/http://www.qiushibaike.com/xml.rss"><img src="http://www.potu.com/sticker/potu_03" alt="使用 POTU 订阅！" /></a>
<a href="http://www.gougou.com/1SHA1AGQ"><img src="http://www.gougou.com/imgs/sub.gif" alt="用狗狗订阅" /></a>
<a href="http://add.my.yahoo.com/rss?url=http://www.qiushibaike.com/xml.rss"><img src="http://us.i1.yimg.com/us.yimg.com/i/us/my/addtomyyahoo4.gif" alt="订阅到My Yahoo!"/></a> 
<a href="http://www.newsgator.com/ngs/subscriber/subext.aspx?url=http://www.qiushibaike.com/xml.rss"><img src="http://www.newsgator.com/images/ngsub1.gif" alt="订阅到NewsGator Online"/></a> 
<a href="http://www.rojo.com/add-subscription?resource=http://www.qiushibaike.com/xml.rss"><img src="http://www.rojo.com/skins/static/images/add-to-rojo.gif" alt="订阅到Rojo"/></a> 
 <hr />
 <xsl:apply-templates select='channel/item' />
 </div>
 </body>
 </html></xsl:template>

<xsl:template match='item'>
 <h2>
 <a href='{link}'>
 <xsl:value-of select='title'/>
 </a>
 </h2>
 <strong>发布时间：</strong><xsl:value-of select='pubDate' />
 <p>
<dd name="decodeable" class="text">
<xsl:call-template name="outputContent"/>
</dd>
 <br />
 <xsl:for-each select='category'>
 <font color='gray'>
 <xsl:value-of select='.' /> |
 </font>
 <br />
 </xsl:for-each>
 </p></xsl:template>
<xsl:template name="outputContent">
		<xsl:choose>
			<xsl:when test="xhtml:body" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<xsl:copy-of select="xhtml:body/*"/>
			</xsl:when>
			<xsl:when test="xhtml:div" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<xsl:copy-of select="xhtml:div"/>
			</xsl:when>

			<xsl:when test="content:encoded" xmlns:content="http://purl.org/rss/1.0/modules/content/">
				<xsl:value-of select="content:encoded" disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:when test="description">
				<xsl:value-of select="description" disable-output-escaping="yes"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
<xsl:template match='category'>
 <xsl:value-of select='.'/> |
</xsl:template></xsl:stylesheet>