<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:for-each select="/Entrezgene-Set/Entrezgene/Entrezgene_locus">
      <xsl:for-each select="Gene-commentary[Gene-commentary_type/@value='genomic' and Gene-commentary_type/text()='1']">
        <xsl:variable name="acn">
          <xsl:value-of select="concat('(',Gene-commentary_heading,')',Gene-commentary_accession)"/>
        </xsl:variable>
        <xsl:for-each select="Gene-commentary_seqs/Seq-loc/Seq-loc_int/Seq-interval">
          <xsl:value-of select="concat($acn,':',Seq-interval_from,'-',Seq-interval_to)"/>
          <xsl:text>
</xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
