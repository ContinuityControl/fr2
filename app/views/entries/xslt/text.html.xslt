<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="E">
    <xsl:variable name="preceding_text" select="preceding-sibling::node()[1][self::text()]" />
    <xsl:if test="contains(');:,.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', substring($preceding_text, string-length($preceding_text)))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <span>
      <xsl:attribute name="class">E-<xsl:value-of select="@T"/></xsl:attribute>  
      <xsl:apply-templates/>	
    </span>
    <xsl:variable name="following_text" select="following-sibling::node()[1][self::text()]" />
    <xsl:if test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(', substring($following_text,1,1))">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="STARS">
    <p class="stars">
      <xsl:text>* * * * *</xsl:text>
    </p>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="parent::node()[name() = 'P' or name() = 'FP'] and starts-with(.,'&#x2022;')">
        <xsl:value-of select="substring(.,2)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="SECTNO">
    <p class="cfr_section">
      <xsl:apply-templates />
      <xsl:text> </xsl:text>
      <xsl:value-of select="following::SUBJECT[text()]/text()" />
    </p>
  </xsl:template>
  
  <xsl:template match="P | FP | AMDPAR | BILCOD">
    <xsl:choose>
      <xsl:when test="starts-with(text(),'&#x2022;')">
        <xsl:if test="not(preceding-sibling::*[name() != 'PRTPAGE'][1][starts-with(text(),'&#x2022;')])">
          <xsl:value-of disable-output-escaping="yes" select="'&lt;ul class=&quot;bullets&quot;&gt;'"/>
        </xsl:if>
        <li>
          <xsl:attribute name="id">
            <xsl:call-template name="paragraph_id" />
          </xsl:attribute>
          <xsl:attribute name="data-page">
            <xsl:call-template name="current_page" />
          </xsl:attribute>
          <xsl:apply-templates />
        </li>
        <xsl:if test="not(following-sibling::*[name() != 'PRTPAGE'][1][starts-with(text(),'&#x2022;')])">
          <xsl:value-of disable-output-escaping="yes" select="'&lt;/ul&gt;'"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:attribute name="id">
            <xsl:call-template name="paragraph_id" />
          </xsl:attribute>
          
          <xsl:attribute name="data-page">
            <xsl:call-template name="current_page" />
          </xsl:attribute>
          
          <xsl:if test="name(.) = 'FP'">
            <xsl:attribute name="class">flush</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="SIG">
    <div class="signature">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template match="DATED">
    <p class="signature_date">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="NAME">
    <p class="name">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="TITLE">
    <p class="title">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="AMDPAR">
    <p class="amendment_part">
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="FRDOC">
    <p class="fr_doc">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="PRTPAGE[not(ancestor::FTNT)]">
    <span class="printed_page">
      <xsl:attribute name="id">
        <xsl:text>page-</xsl:text><xsl:value-of select="@P" />
      </xsl:attribute>
      <xsl:attribute name="data-page">
        <xsl:value-of select="@P" />
      </xsl:attribute>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template name="paragraph_id">
    <xsl:value-of select="concat('p-', count(preceding::*[name(.) = 'P' or name(.) = 'FP'])+1)" />
  </xsl:template>
  
  <xsl:template name="current_page">
    <xsl:variable name="current_page">
      <xsl:value-of select="preceding::PRTPAGE[not(ancestor::FTNT)][1]/@P" />
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="number($current_page)">
        <xsl:value-of select="$current_page" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$first_page" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
