<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:me="http://www.menota.org/ns/1.0" version="2.0" exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" >
    <xsl:output encoding="UTF-8" method="xml" />
    <xsl:strip-space elements="*"/>
    
    <!-- !! TEXT-NUMBER to be filled in manually before transformation !! -->
    <xsl:variable name="text-number" select="1"/>
    
<!-- Copyright (C) 2018 Beeke Stegmann

Author: Beeke Stegmann <beeke.stegmann@gmail.com>
Version: 0.1

This stylesheet is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This stylesheet is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GNU General Public License is available at <http://www.gnu.org/licenses/>. -->
    
    <xsl:template match="TEI"> 
        
        <!-- create main text number -->
        <xsl:text>&#x0a;* </xsl:text><xsl:value-of select="$text-number"/><xsl:text> (TEXT-NUMBER)</xsl:text>
      
      
        <!-- create line with meta information (drawn from header) -->
        <xsl:text>&#x0a;| :m: | </xsl:text>
        
        <!-- main text number (project specific running number) -->
        <xsl:value-of select="$text-number"/>
        <xsl:text> | </xsl:text>
        
        <!-- empty field (can be used for title, which is usually only used for chapters -->
        <xsl:text> | </xsl:text>
        
        <!-- add ID (i.e. shelfmark or main title of document) -->
        <xsl:choose>
            <xsl:when test="descendant::msIdentifier/descendant::idno"><xsl:value-of select="descendant::msIdentifier/descendant::idno"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="descendant::titleStmt/title"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- add year (from origDate or origin) -->
        <xsl:choose>
        <xsl:when test="descendant::origDate">
            <xsl:choose>
                <xsl:when test="descendant::origDate[attribute::when]">
                    <xsl:choose>
                        <xsl:when test="descendant::origDate/@when/contains(., '-')">
                            <xsl:value-of select="descendant::origDate/@when/substring-before(., '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="descendant::origDate/@when"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="descendant::origDate[attribute::notBefore]"><xsl:value-of select="descendant::origDate/@notBefore"/><xsl:text>-</xsl:text><xsl:value-of select="descendant::origDate/@notAfter"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="descendant::origDate"/></xsl:otherwise>
            </xsl:choose>
        </xsl:when>
            <xsl:when test="descendant::origin/descendant::date">
                <xsl:choose>
                    <xsl:when test="descendant::origin/descendant::date/attribute::when">
                        
                        <xsl:choose>
                            <xsl:when test="descendant::origin/descendant::date/@when/contains(., '-')">
                                <xsl:value-of select="descendant::origin/descendant::date/@when/substring-before(., '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="descendant::origin/descendant::date/@when"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:when test="descendant::origin/descendant::date/attribute::notBefore"><xsl:value-of select="descendant::origin/descendant::date/@notBefore"/><xsl:text>-</xsl:text><xsl:value-of select="descendant::origin/descendant::date/@notAfter"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="descendant::origin/descendant::date"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- add date (month and day) (from origDate or origin) -->
        <xsl:choose>
            <xsl:when test="descendant::origDate">
                <xsl:choose>
                    <xsl:when test="descendant::origDate[attribute::when]">
                        <xsl:choose>
                            <xsl:when test="descendant::origDate/@when/contains(., '-')">
                                <xsl:value-of select="descendant::origDate/@when/substring-after(., '-')"/>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="descendant::origin/descendant::date">
                <xsl:choose>
                    <xsl:when test="descendant::origin/descendant::date/attribute::when">
                        
                        <xsl:choose>
                            <xsl:when test="descendant::origin/descendant::date/@when/contains(., '-')">
                                <xsl:value-of select="descendant::origin/descendant::date/@when/substring-after(., '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                     </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- add repositorya and settlement-->
        <xsl:if test="descendant::msIdentifier/descendant::settlement"><xsl:value-of select="descendant::msIdentifier/descendant::settlement"/></xsl:if>
        <xsl:if test="descendant::msIdentifier/descendant::repository"><xsl:text>, </xsl:text><xsl:value-of select="descendant::msIdentifier/descendant::repository"/></xsl:if>
        
        <xsl:text> | </xsl:text>
        
        <xsl:text> |  |  |  |  |  |  |  |  |  |</xsl:text> <!-- end meta info line -->
       
       <!-- create org-mode syntax for note -->
        <xsl:text>&#x0a;** Notes</xsl:text>
        
        <!-- copy-paste header info as subchapter of notes -->
        <xsl:text>&#x0a;*** XML header</xsl:text>
        <xsl:text>&#x0a;#+BEGIN_SRC xml&#x0a;</xsl:text>
       <xsl:copy-of select="teiHeader" copy-namespaces="no" /> <!-- Note: inserts too many attributes if Menota schema is present in input -->
        <xsl:text>&#x0a;#+END_SRC</xsl:text>
        
        <!-- copy-paste facsimile info (if present) as subchapter of notes -->
       <xsl:choose>
           <xsl:when test="descendant::facsimile">
        <xsl:text>&#x0a;*** XML facsimile info</xsl:text>
               <xsl:text>&#x0a;#+BEGIN_SRC xml&#x0a;</xsl:text>
               <xsl:copy-of select="facsimile" copy-namespaces="no"/>
               <xsl:text>&#x0a;#+END_SRC</xsl:text>
           </xsl:when>
       </xsl:choose>
        
        <!-- copy-paste front/back info (if present) as subchapter of notes -->
            <xsl:if test="descendant::text[descendant::front]">
                <xsl:text>&#x0a;*** XML front matter</xsl:text>
                <xsl:text>&#x0a;#+BEGIN_SRC xml&#x0a;</xsl:text>
                <xsl:copy-of select="descendant::text/descendant::front" copy-namespaces="no"/>
                <xsl:text>&#x0a;#+END_SRC</xsl:text>
            </xsl:if>
        <xsl:if test="descendant::text[descendant::back]">
            <xsl:text>&#x0a;*** XML back matter</xsl:text>
            <xsl:text>&#x0a;#+BEGIN_SRC xml&#x0a;</xsl:text>
            <xsl:copy-of select="descendant::text/descendant::back" copy-namespaces="no"/>
            <xsl:text>&#x0a;#+END_SRC</xsl:text>
        </xsl:if>
        
        <xsl:apply-templates/> <!-- call templates for transcription transformation -->
    </xsl:template>
      
    <!-- suppress teiHeader and facsimile elements during regular processing -->
    <xsl:template match="teiHeader|facsimile|front|back"/>
    
    
    <xsl:template match="text/body"> 
        
        <!-- create the same syntax for each text (or chapter) starting with subline for meta data, followed by space for notes and the transcription -->
        <xsl:for-each select="child::div">
            
            <!-- create text number (for individual chapter) and potentially show the title -->
            <xsl:text>&#x0a;** </xsl:text><xsl:number format="1" from="body" level="single" count="//div"/> 
            <xsl:if test="head"><xsl:text> (</xsl:text><xsl:value-of select="head"/><xsl:text>)</xsl:text></xsl:if>
            
            <!-- create line with meta information (drawn from header) -->
            <xsl:text>&#x0a;| :m: | </xsl:text>
            
            <!-- text and chapter number -->
            <xsl:value-of select="$text-number"/><xsl:text>:</xsl:text><xsl:number format="1" from="body" level="single" count="//div"/> 
            <xsl:text> | </xsl:text>
            
            <!-- add title -->
            <xsl:if test="head"><xsl:text>(</xsl:text><xsl:value-of select="head"/><xsl:text>)</xsl:text></xsl:if>
            <xsl:text> | </xsl:text>
            
            <!-- add ID (i.e. shelfmark or main title of document) -->
            <xsl:choose>
                <xsl:when test="ancestor::TEI/descendant::msIdentifier/descendant::idno"><xsl:value-of select="ancestor::TEI/descendant::msIdentifier/descendant::idno"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="ancestor::TEI/descendant::titleStmt/title"/></xsl:otherwise>
            </xsl:choose>
            <xsl:text> | </xsl:text>
            
            <!-- add year (from origDate or origin) -->
            <xsl:choose>
                <xsl:when test="ancestor::TEI/descendant::origDate">
                    <xsl:choose>
                        <xsl:when test="ancestor::TEI/descendant::origDate[attribute::when]">
                            <xsl:choose>
                                <xsl:when test="ancestor::TEI/descendant::origDate/@when/contains(., '-')">
                                    <xsl:value-of select="ancestor::TEI/descendant::origDate/@when/substring-before(., '-')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ancestor::TEI/descendant::origDate/@when"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="ancestor::TEI/descendant::origDate[attribute::notBefore]"><xsl:value-of select="ancestor::TEI/descendant::origDate/@notBefore"/><xsl:text>-</xsl:text><xsl:value-of select="ancestor::TEI/descendant::origDate/@notAfter"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="ancestor::TEI/descendant::origDate"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ancestor::TEI/descendant::origin/descendant::date">
                    <xsl:choose>
                        <xsl:when test="ancestor::TEI/descendant::origin/descendant::date/attribute::when">
                            
                            <xsl:choose>
                                <xsl:when test="ancestor::TEI/descendant::origin/descendant::date/@when/contains(., '-')">
                                    <xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date/@when/substring-before(., '-')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date/@when"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:when>
                        <xsl:when test="ancestor::TEI/descendant::origin/descendant::date/attribute::notBefore"><xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date/@notBefore"/><xsl:text>-</xsl:text><xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date/@notAfter"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
            <xsl:text> | </xsl:text>
            
            <!-- add date (month and day) (from origDate or origin) -->
            <xsl:choose>
                <xsl:when test="ancestor::TEI/descendant::origDate">
                    <xsl:choose>
                        <xsl:when test="ancestor::TEI/descendant::origDate[attribute::when]">
                            <xsl:choose>
                                <xsl:when test="ancestor::TEI/descendant::origDate/@when/contains(., '-')">
                                    <xsl:value-of select="ancestor::TEI/descendant::origDate/@when/substring-after(., '-')"/>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ancestor::TEI/descendant::origin/descendant::date">
                    <xsl:choose>
                        <xsl:when test="ancestor::TEI/descendant::origin/descendant::date/attribute::when">
                            
                            <xsl:choose>
                                <xsl:when test="ancestor::TEI/descendant::origin/descendant::date/@when/contains(., '-')">
                                    <xsl:value-of select="ancestor::TEI/descendant::origin/descendant::date/@when/substring-after(., '-')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
            <xsl:text> | </xsl:text>
            
            <!-- add repository and settlement-->
            <xsl:if test="ancestor::TEI/descendant::msIdentifier/descendant::settlement"><xsl:value-of select="ancestor::TEI/descendant::msIdentifier/descendant::settlement"/></xsl:if>
            <xsl:if test="ancestor::TEI/descendant::msIdentifier/descendant::repository"><xsl:text>, </xsl:text><xsl:value-of select="ancestor::TEI/descendant::msIdentifier/descendant::repository"/></xsl:if>
            
            <xsl:text> | </xsl:text>
            
            <xsl:text> |  |  |  |  |  |  |  |  |  |</xsl:text> <!-- end meta info line -->
            
            <!-- create org-mode syntax for note -->
            <xsl:text>&#x0a;*** Notes</xsl:text>
            
            <!-- create org-mode syntax for transcriotion -->
            <xsl:text>&#x0a;*** Transcription&#x0a;</xsl:text>
            
        
      
        <!-- create framing structure with :s: and :e: around transcription -->
        <xsl:text>| :s: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | &#x0a;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>| :e: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | &#x0a;</xsl:text> 
       
        </xsl:for-each>
    </xsl:template>
    
    <!-- for words, punctuation characters and numbers -->
    <xsl:template match="w[not(ancestor::orig[@rend])]|me:punct|pc|num"> 
        
        <!-- add additional opening line for editorial markup within word, punctuation or number, that carries extra attributes --> 
        <!-- OBS: Since non of the XML standards have an in-word coding for transposition, this is not taken into consideration here. -->
        <xsl:if test="descendant::add|descendant::del|descendant::supplied|descendant::supplied|descendant::me:suppressed|descendant::me:expunged|descendant::surplus|descendant::unclear|descendant::gap|descendant::gb|descendant::space|descendant::handShift|descendant::me:punct[attribute::type='supplied']">
            
            
            <xsl:choose><!-- test for extra attributes and insert beginning line with correct type desgination followed bz "X" to mark that it onlz related to part of the following word -->
                <xsl:when test="descendant::add[attribute::*]"><xsl:text>| ad  | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::del[attribute::*]"><xsl:text>| de  | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::supplied[attribute::*]|descendant::me:punct[attribute::type='supplied']"><xsl:text>| su | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::me:suppressed[attribute::*]|descendant::surplus[attribute::*]|descendant::me:expunged[attribute::*]"><xsl:text>| sd | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::unclear[attribute::*]"><xsl:text>| uc | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::gap[attribute::*]"><xsl:text>| ga | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::gb[attribute::*]"><xsl:text>| gb | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::space[attribute::*]"><xsl:text>| sp | X | </xsl:text></xsl:when>
                <xsl:when test="descendant::handShift[attribute::*]"><xsl:text>| hs | X | </xsl:text></xsl:when>
            </xsl:choose>
            
            <xsl:choose> <!-- get attributes for del, add supplied, me:suppressed, surplus, me:expunged and unclear (in same order as in beginning/end-lines)-->
                <xsl:when test="descendant::del[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::del[attribute::type][1]"><xsl:value-of select="descendant::del[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::del[attribute::reason][1]"><xsl:value-of select="descendant::del[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::del[attribute::resp][1]"><xsl:value-of select="descendant::del[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::del[attribute::hand][1]"><xsl:value-of select="descendant::del[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::del[attribute::rend][1]"><xsl:value-of select="descendant::del[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::del[attribute::place][1]"><xsl:value-of select="descendant::del[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::del[attribute::agent][1]"><xsl:value-of select="descendant::del[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::del[attribute::source][1]"><xsl:value-of select="descendant::del[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::add[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::add[attribute::type][1]"><xsl:value-of select="descendant::add[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::add[attribute::reason][1]"><xsl:value-of select="descendant::add[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::add[attribute::resp][1]"><xsl:value-of select="descendant::add[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::add[attribute::hand][1]"><xsl:value-of select="descendant::add[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::add[attribute::rend][1]"><xsl:value-of select="descendant::add[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::add[attribute::place][1]"><xsl:value-of select="descendant::add[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::add[attribute::agent][1]"><xsl:value-of select="descendant::add[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::add[attribute::source][1]"><xsl:value-of select="descendant::add[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::supplied[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::supplied[attribute::type][1]"><xsl:value-of select="descendant::supplied[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::supplied[attribute::reason][1]"><xsl:value-of select="descendant::supplied[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::supplied[attribute::resp][1]"><xsl:value-of select="descendant::supplied[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::supplied[attribute::hand][1]"><xsl:value-of select="descendant::supplied[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::supplied[attribute::rend][1]"><xsl:value-of select="descendant::supplied[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::supplied[attribute::place][1]"><xsl:value-of select="descendant::supplied[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::supplied[attribute::agent][1]"><xsl:value-of select="descendant::supplied[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::supplied[attribute::source][1]"><xsl:value-of select="descendant::supplied[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::me:punct[attribute::type='supplied']">
                    <xsl:text> | </xsl:text>  <!-- do not print value of @type, since predefined-->
                    
                    <xsl:text> | </xsl:text>  <!-- add value of @subtype-->
                    <xsl:if test="descendant::me:punct[attribute::subtype][1]"><xsl:value-of select="descendant::me:punct[attribute::subtype][1]/attribute::subtype"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::me:punct[attribute::resp][1]"><xsl:value-of select="descendant::me:punct[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::me:punct[attribute::hand][1]"><xsl:value-of select="descendant::me:punct[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::me:punct[attribute::rend][1]"><xsl:value-of select="descendant::me:punct[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::me:punct[attribute::place][1]"><xsl:value-of select="descendant::me:punct[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::me:punct[attribute::agent][1]"><xsl:value-of select="descendant::me:punct[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::me:punct[attribute::source][1]"><xsl:value-of select="descendant::me:punct[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
              
                <xsl:when test="descendant::me:suppressed[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::me:suppressed[attribute::type][1]"><xsl:value-of select="descendant::me:suppressed[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::me:suppressed[attribute::reason][1]"><xsl:value-of select="descendant::me:suppressed[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::me:suppressed[attribute::resp][1]"><xsl:value-of select="descendant::me:suppressed[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::me:suppressed[attribute::hand][1]"><xsl:value-of select="descendant::me:suppressed[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::me:suppressed[attribute::rend][1]"><xsl:value-of select="descendant::me:suppressed[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::me:suppressed[attribute::place][1]"><xsl:value-of select="descendant::me:suppressed[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::me:suppressed[attribute::agent][1]"><xsl:value-of select="descendant::me:suppressed[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::me:suppressed[attribute::source][1]"><xsl:value-of select="descendant::me:suppressed[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                
                <xsl:when test="descendant::surplus[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::surplus[attribute::type][1]"><xsl:value-of select="descendant::surplus[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::surplus[attribute::reason][1]"><xsl:value-of select="descendant::surplus[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::surplus[attribute::resp][1]"><xsl:value-of select="descendant::surplus[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::surplus[attribute::hand][1]"><xsl:value-of select="descendant::surplus[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::surplus[attribute::rend][1]"><xsl:value-of select="descendant::surplus[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::surplus[attribute::place][1]"><xsl:value-of select="descendant::surplus[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::surplus[attribute::agent][1]"><xsl:value-of select="descendant::surplus[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::surplus[attribute::source][1]"><xsl:value-of select="descendant::surplus[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::me:expunged[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::me:expunged[attribute::type][1]"><xsl:value-of select="descendant::me:expunged[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::me:expunged[attribute::reason][1]"><xsl:value-of select="descendant::me:expunged[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::me:expunged[attribute::resp][1]"><xsl:value-of select="descendant::me:expunged[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::me:expunged[attribute::hand][1]"><xsl:value-of select="descendant::me:expunged[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::me:expunged[attribute::rend][1]"><xsl:value-of select="descendant::me:expunged[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::me:expunged[attribute::place][1]"><xsl:value-of select="descendant::me:expunged[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::me:expunged[attribute::agent][1]"><xsl:value-of select="descendant::me:expunged[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::me:expunged[attribute::source][1]"><xsl:value-of select="descendant::me:expunged[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::unclear[attribute::*]">
                    <xsl:text> | </xsl:text>  <!-- add value of @type-->
                    <xsl:if test="descendant::unclear[attribute::type][1]"><xsl:value-of select="descendant::unclear[attribute::type][1]/attribute::type"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @reason-->
                    <xsl:if test="descendant::unclear[attribute::reason][1]"><xsl:value-of select="descendant::unclear[attribute::reason][1]/attribute::reason"/></xsl:if>
                    <xsl:text> | </xsl:text>    <!-- add value of @resp-->
                    <xsl:if test="descendant::unclear[attribute::resp][1]"><xsl:value-of select="descendant::unclear[attribute::resp][1]/attribute::resp"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @hand-->
                    <xsl:if test="descendant::unclear[attribute::hand][1]"><xsl:value-of select="descendant::unclear[attribute::hand][1]/attribute::hand"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @rend-->
                    <xsl:if test="descendant::unclear[attribute::rend][1]"><xsl:value-of select="descendant::unclear[attribute::rend][1]/attribute::rend"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @place-->
                    <xsl:if test="descendant::unclear[attribute::place][1]"><xsl:value-of select="descendant::unclear[attribute::place][1]/attribute::place"/></xsl:if>
                    <xsl:text> | </xsl:text>  <!-- add value of @agent-->
                    <xsl:if test="descendant::unclear[attribute::agent][1]"><xsl:value-of select="descendant::unclear[attribute::agent][1]/attribute::agent"/></xsl:if>
                    <xsl:text> | </xsl:text>   <!-- add value of @source-->
                    <xsl:if test="descendant::unclear[attribute::source][1]"><xsl:value-of select="descendant::unclear[attribute::source][1]/attribute::source"/></xsl:if>
                    <xsl:text> |  |  |  |  |  |  | &#x0a;</xsl:text> <!-- empty fields and end of line line-->
                </xsl:when>
                
                <xsl:when test="descendant::gap[attribute::*]">    <!-- get attributes for gap  (same order as is beginning/end lines-->
                    <xsl:text> | </xsl:text> <!-- get @quantity or @extent -->
                    <xsl:choose>
                        <xsl:when test="attribute::quantity"><xsl:value-of select="."/></xsl:when>
                        <xsl:when test="attribute::extent"><xsl:value-of select="."/></xsl:when>
                    </xsl:choose>
                    <xsl:text> | </xsl:text> <!-- get @reason  -->
                    <xsl:value-of select="attribute::reason"/>
                    <xsl:text> | </xsl:text> <!-- get @agent -->
                    <xsl:value-of select="attribute::agent"/>
                    <xsl:text> | </xsl:text> <!-- get @resp -->
                    <xsl:value-of select="attribute::resp"/>
                    <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  |&#x0a;</xsl:text> <!-- empty fields and end of line-->
                </xsl:when>
                
                <xsl:when test="descendant::gb[attribute::*]"> <!-- get attributes for gb -->
                    <xsl:text> | </xsl:text> <!-- get @n -->
                    <xsl:value-of select="attribute::n"/>
                    <xsl:text> | </xsl:text>
                    <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |&#x0a;</xsl:text> <!-- empty fields and end of line-->
                </xsl:when>
                
                <xsl:when test="descendant::space[attribute::*]"> <!-- get attributes for space -->
                    <xsl:text> | </xsl:text>  <!-- add vertical extent for space and potentially unit -->
                    <xsl:choose>
                        <xsl:when test="attribute::quantity"><xsl:value-of select="attribute::quantity"/></xsl:when>
                        <xsl:when test="attribute::extent"><xsl:value-of select="attribute::extent"/></xsl:when>
                    </xsl:choose>
                    <xsl:if test="attribute::unit"><xsl:text>_</xsl:text><xsl:value-of select="attribute::unit"/></xsl:if>
                    <xsl:text> | </xsl:text> <!-- get @dim (i.e. info if vertical or horizontal) -->
                    <xsl:value-of select="attribute::dim"/>
                    <xsl:text> | </xsl:text> <!-- empty field -->
                    <xsl:text> | </xsl:text> <!-- get @resp -->
                    <xsl:value-of select="attribute::resp"/>
                    <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  |&#x0a;</xsl:text> <!-- empty fields and end of line-->
                </xsl:when>
                
                <xsl:when test="descendant::handShift[attribute::*]"> <!-- get attributes for handShift -->
                    <xsl:text> | </xsl:text> <!-- get @new -->
                    <xsl:value-of select="attribute::new"/>
                    <xsl:text> | </xsl:text>
                    <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |&#x0a;</xsl:text> <!-- empty fields and end of line-->
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        
        <xsl:text>| </xsl:text>         <!-- beginning of ordenary line -->
        <xsl:choose> <!-- insert correct type designation -->
            <xsl:when test="self::w[not(ancestor::gap)][not(ancestor::orig[@rend])]"><xsl:text>w</xsl:text></xsl:when>  <!-- regular words (not marked as gap or original order in transposition acc. to Menota) -->
            <xsl:when test="self::w[ancestor::gap]"><xsl:text>L</xsl:text></xsl:when> <!-- words that are marked completely as gap (i.e. lost words) -->
            <xsl:when test="self::me:punct[not(ancestor::w)]|self::pc"><xsl:text>p</xsl:text></xsl:when>   <!-- punctuation -->
            <xsl:when test="self::num"><xsl:text>w</xsl:text></xsl:when> <!-- numbers -->
        </xsl:choose>                       
        <xsl:text> | </xsl:text>  
       
        <xsl:choose><!-- lemma1 (i.e. alternative lemma) -->
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::me:orig-lemma">
                    <xsl:choose>
                        <xsl:when test="self::w/attribute::me:orig-lemma/contains(., '|')"><xsl:value-of select="self::w/attribute::me:orig-lemma/replace(., '|', '¦')"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="self::w/attribute::me:orig-lemma"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:orig-lemma">
                    <xsl:choose>
                        <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:orig-lemma/contains(., '|')"><xsl:value-of select="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:orig-lemma/replace(., '|', '¦')"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:orig-lemma"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <xsl:choose><!-- lemma2 (i.e. primary lemma) -->
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::lemma">
                <xsl:choose>
                    <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::lemma/contains(., '|')"><xsl:value-of select="self::w[not(ancestor::orig[@rend])]/attribute::lemma/replace(., '|', '¦')"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="self::w/attribute::lemma"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::lemma">
                <xsl:choose>
                    <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::lemma/contains(., '|')"><xsl:value-of select="self::num/child::w[not(ancestor::orig[@rend])]/attribute::lemma/replace(., '|', '¦')"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="self::num/child::w[not(ancestor::orig[@rend])]/attribute::lemma"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::num[not(child::w)]/attribute::value">
                <xsl:value-of select="self::num[not(child::w)]/attribute::value"/>
            </xsl:when>
            <xsl:when test="self::num[child::w/not(attribute::lemma)]/attribute::value">
                <xsl:value-of select="self::num[child::w/not(attribute::lemma)]/attribute::value"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <xsl:choose><!-- msa --> <!-- if homonymous msa separated by pipe character, replace with broken bar -->
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::me:msa[contains(., '|')]"><xsl:value-of select="attribute::me:msa/replace(., '|', '¦')"/></xsl:when> 
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::me:msa[not(contains(., '|'))]"><xsl:value-of select="attribute::me:msa"/></xsl:when>  
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::type[contains(., '|')]"><xsl:value-of select="attribute::type/replace(., '|', '¦')"/></xsl:when>  
            <xsl:when test="self::w[not(ancestor::orig[@rend])]/attribute::type[not(contains(., '|'))]"><xsl:value-of select="attribute::type"/></xsl:when>  
            <xsl:when test="self::num[not(attribute::type)][not(child::w)]"><xsl:text>xNA</xsl:text></xsl:when>
            
            <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:msa[contains(., '|')]"><xsl:value-of select="self::num/child::w/attribute::me:msa/replace(., '|', '¦')"/></xsl:when> 
            <xsl:when test="self::num/child::w[not(ancestor::orig[@rend])]/attribute::me:msa[not(contains(., '|'))]"><xsl:value-of select="self::num/child::w/attribute::me:msa"/></xsl:when>   
            <xsl:when test="self::num/attribute::type[contains(., '|')]"><xsl:value-of select="attribute::type/replace(., '|', '¦')"/></xsl:when>  
            <xsl:when test="self::num/attribute::type[not(contains(., '|'))]">
                <xsl:choose>
                    <xsl:when test="attribute::type='cardinal'"><xsl:text>xNA</xsl:text></xsl:when>
                    <xsl:when test="attribute::type='ordinal'"><xsl:text>xNO</xsl:text></xsl:when>
                    <xsl:when test="attribute::fraction"><xsl:text>xNF</xsl:text></xsl:when>
                    <xsl:when test="attribute::percentage"><xsl:text>xNH</xsl:text></xsl:when> 
                    <xsl:otherwise><xsl:value-of select="attribute::type"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>  
            <xsl:when test="self::num[not(attribute::type)][child::w[not(ancestor::orig[@rend])]/not(attribute::me:msa)]"><xsl:text>xNA</xsl:text></xsl:when>
            
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
         <!-- norm1 -->
           <!-- not expected in any incomming XML files (ASK will think about it some more) -->
        <xsl:text> | </xsl:text>
        
        <xsl:choose> <!-- norm2  -->
        <xsl:when test="descendant::me:norm|descendant::reg">  
            
            <!-- add repeated markup for editorial markup that is outside of <w> (same sings as for inside of words) -->
            <xsl:if test="ancestor::unclear"><xsl:text>{</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟨</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟨</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>[</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸍⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸌⸌</xsl:text></xsl:if> 
            <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸍⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸝</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸜</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::sic"><xsl:text>!</xsl:text></xsl:if>
            <xsl:if test="ancestor::corr"><xsl:text>*</xsl:text></xsl:if>
            <xsl:if test="ancestor::del"><xsl:text>⸠</xsl:text></xsl:if>
            <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸡</xsl:text></xsl:if>
             
            <!-- get contents (including editorial markup within <w>) -->
            <xsl:if test="descendant::me:norm"><xsl:apply-templates select="descendant::me:norm"/></xsl:if>
            <xsl:if test="descendant::reg"><xsl:apply-templates select="descendant::reg"/></xsl:if>
            <xsl:if test="self::num[not(child::w)][descendant::reg]"><xsl:value-of select="descendant::reg"></xsl:value-of></xsl:if>
            <xsl:if test="self::num[not(child::w)][descendant::me:norm]"><xsl:value-of select="descendant::me:norm"></xsl:value-of></xsl:if>
            
        
        <!-- add repeated markup for editorial markup that is outside of <w>  -->
            <xsl:if test="ancestor::unclear"><xsl:text>}</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟩</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟩</xsl:text></xsl:if>
            <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>]</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸌⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸍⸍</xsl:text></xsl:if> 
            <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸌⸌</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸜</xsl:text></xsl:if>
            <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸝</xsl:text></xsl:if>
            <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸍</xsl:text></xsl:if>
            <xsl:if test="ancestor::sic"><xsl:text>¡</xsl:text></xsl:if>
            <xsl:if test="ancestor::corr"><xsl:text></xsl:text></xsl:if> <!-- nothing to end corr -->
            <xsl:if test="ancestor::del"><xsl:text>⸡</xsl:text></xsl:if>
            <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸠</xsl:text></xsl:if>
            
        </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <xsl:choose> <!-- dipl -->
            <xsl:when test="descendant::me:dipl|descendant::orig|descendant::text()[not(ancestor::orig or ancestor::red or ancestor::me:norm or ancestor::me:dipl or ancestor::me:facs)]">  
         
                <!-- add repeated markup (beginning) for editorial markup that is outside of <w> (same sings as for inside of words) -->
                <xsl:if test="ancestor::unclear"><xsl:text>{</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟨</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟨</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>[</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸍⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸌⸌</xsl:text></xsl:if> 
                <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸍⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸝</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸜</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::sic"><xsl:text>!</xsl:text></xsl:if>
                <xsl:if test="ancestor::corr"><xsl:text>*</xsl:text></xsl:if>
                <xsl:if test="ancestor::del"><xsl:text>⸠</xsl:text></xsl:if>
                <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸡</xsl:text></xsl:if>
                
                <!-- get contents (including editorial markup within <w> if present) -->
               <xsl:choose>
                   <xsl:when test="descendant-or-self::me:dipl"><xsl:apply-templates select="descendant-or-self::me:dipl"/></xsl:when>
                <xsl:when test="descendant-or-self::orig">
                    <xsl:apply-templates select="descendant::orig/unclear/text()|descendant::orig/text() | descendant::ex|descendant::expan | descendant::orig/descendant::supplied|descendant::orig/descendant::gap| descendant::orig/descendant::surplus| descendant::orig/descendant::me:suppressed| descendant::orig/descendant::me:expunged |descendant::orig/descendant::sic|descendant::orig/descendant::corr|descendant::orig/descendant::lb|descendant::orig/descendant::pb|descendant::orig/descendant::cb|descendant::orig/descendant::c|descendant::orig/descendant::hi"/> <!-- add more? -->
                </xsl:when>
                   <xsl:otherwise><xsl:apply-templates select="child::text()|descendant::unclear[not(ancestor::sic)]|descendant::ex|descendant::expan|descendant::supplied|descendant::gap|descendant::surplus|descendant::suppressed|descendant::me:expunged|descendant::corr|descendant::lb|descendant::pb|descendant::cb|descendant::c|descendant::hi"/></xsl:otherwise>
               </xsl:choose>
                <xsl:if test="self::num[not(child::w)][descendant::orig]"><xsl:value-of select="self::num[not(child::w)]/descendant::orig"/></xsl:if>
                <xsl:if test="self::num[not(child::w)][descendant::me:dipl]"><xsl:value-of select="self::num[not(child::w)]/descendant::me:dipl"/></xsl:if>
                
                <!-- add repeated markup (end) for editorial markup that is outside of <w>  -->
                <xsl:if test="ancestor::unclear"><xsl:text>}</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟩</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟩</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>]</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸌⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸍⸍</xsl:text></xsl:if> 
                <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸌⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸜</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸝</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::sic"><xsl:text>¡</xsl:text></xsl:if>
                <xsl:if test="ancestor::corr"><xsl:text></xsl:text></xsl:if> <!-- nothing to end corr -->
                <xsl:if test="ancestor::del"><xsl:text>⸡</xsl:text></xsl:if>
                <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸠</xsl:text></xsl:if>
                
            </xsl:when>
        </xsl:choose>
        
        <xsl:text> | </xsl:text>
        
        <xsl:choose> <!-- facs -->
            <xsl:when test="descendant::me:facs|descendant::orig|descendant::sic[not(ancestor::orig or ancestor::reg or ancestor::me:norm or ancestor::me:dipl or ancestor::me:facs)]">  
                
                <!-- add repeated markup (beginning) for editorial markup that is outside of <w> (same sings as for inside of words) -->
                <xsl:if test="ancestor::unclear"><xsl:text>{</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟨</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟨</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>[</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸍⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸌⸌</xsl:text></xsl:if> 
                <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸍⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸝</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸜</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::sic"><xsl:text>!</xsl:text></xsl:if>
                <xsl:if test="ancestor::corr"><xsl:text>*</xsl:text></xsl:if>
                <xsl:if test="ancestor::del"><xsl:text>⸠</xsl:text></xsl:if>
                <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸡</xsl:text></xsl:if>
                
                <!-- get contents (including editorial markup within <w>) -->
                <xsl:choose>
                <xsl:when test="descendant-or-self::me:facs"><xsl:apply-templates select="descendant::me:facs"/></xsl:when>
                <xsl:when test="descendant-or-self::orig">
                    <xsl:apply-templates select="descendant::orig/unclear/text() | descendant::orig/text()|descendant::am |descendant::abbr| descendant::orig/descendant::supplied|descendant::orig/descendant::gap|descendant::orig/descendant::surplus| descendant::orig/descendant::me:suppressed| descendant::orig/descendant::me:expunged | descendant::orig/descendant::sic | descendant::orig/descendant::corr|descendant::orig/descendant::lb|descendant::orig/descendant::pb|descendant::orig/descendant::cb|descendant::orig/descendant::c|descendant::orig/descendant::hi"/> <!-- add more? -->
                    </xsl:when>
                    <xsl:otherwise><xsl:apply-templates select="descendant-or-self::sic"></xsl:apply-templates></xsl:otherwise>
                </xsl:choose>
                <xsl:if test="self::num[not(child::w)][descendant::orig]"><xsl:value-of select="self::num[not(child::w)]/descendant::orig"/></xsl:if>
                <xsl:if test="self::num[not(child::w)][descendant::me:facs]"><xsl:value-of select="self::num[not(child::w)]/descendant::me:facs"/></xsl:if>
                
                
                <!-- add repeated markup (end) for editorial markup that is outside of <w>  -->
                <xsl:if test="ancestor::unclear"><xsl:text>}</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/not(attribute::reason='omitted') and not(attribute::reason='illegible')"><xsl:text>⟩</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='omitted'"><xsl:text>⟩</xsl:text></xsl:if>
                <xsl:if test="ancestor::supplied/attribute::reason='illegible'"><xsl:text>]</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[not(attribute::place='margin-right') and not(attribute::place='margin-left') and not(attribute::place='margin-top') and not(attribute::place='margin-bot')]/attribute::place/starts-with(., 'margin')"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-right'"><xsl:text>⸌⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-left'"><xsl:text>⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/attribute::place='margin-top'"><xsl:text>⸍⸍</xsl:text></xsl:if> 
                <xsl:if test="ancestor::add/attribute::place='margin-bot'"><xsl:text>⸌⸌</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='above']|ancestor::add[attribute::place='supralinear']"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='below']|ancestor::add[attribute::place='infralinear']"><xsl:text>⸜</xsl:text></xsl:if>
                <xsl:if test="ancestor::add[attribute::place='inline']|ancestor::add[attribute::place='interlinear']"><xsl:text>⸝</xsl:text></xsl:if>
                <xsl:if test="ancestor::add/not(attribute::place/starts-with(., 'margin'))"><xsl:text>⸍</xsl:text></xsl:if>
                <xsl:if test="ancestor::sic"><xsl:text>¡</xsl:text></xsl:if>
                <xsl:if test="ancestor::corr"><xsl:text></xsl:text></xsl:if> <!-- nothing to end corr -->
                <xsl:if test="ancestor::del"><xsl:text>⸡</xsl:text></xsl:if>
                <xsl:if test="ancestor::surplus|ancestor::me:suppressed|ancestor::me:expunged"><xsl:text>⸠</xsl:text></xsl:if>
                
            </xsl:when> 
               </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- word/punctuation counter  --> 
        <!-- NOTE: This function counts elements (nodes), not images and thus does not give two counts for words that are written over two lines. 
         A correcting counter function that counts images rather than words is supposed to be run in the elisp part of the program and to overwrite the numbers generated here.
         The word count is also thrown off by potential encoding of transposition and needs to be corrected for that. -->
        <xsl:number format="000001" from="body" level="any" count="//w|//me:punct|//pc|//num">  
        </xsl:number>
        <!-- if reordering of words is present (marked up by means of <lb/> with @rend), add the relative value of @rend in parentheses to mark the place in line (needs afterprocessing by eLisp)  -->
        <xsl:if test="preceding::lb[1][attribute::rend]">
            <xsl:choose>
                <xsl:when test="preceding::lb[1][attribute::rend='hyphen']"></xsl:when> <!-- if rend indicates a hyphen don't do anything -->
                <xsl:otherwise> <!-- otherwise (i.e. if rend indicates reordering) print number -->
                <!--    <xsl:variable name="lb-number" select="self::lb/attribute::n"/>  -->  
                    <xsl:variable name="transposition-number" select="preceding::lb[1]/attribute::rend"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="$transposition-number"/> <!-- get @rend number -->
                    <xsl:text>)</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if> 
        <!-- if words are part of transposition (marked in manuscript), add square brackets for original number in sequence 
            (OBS: Currently not working! Needs to be filled in by hand) -->
        
        <xsl:if test="self::w/parent::reg[@type='transposition']">  <!-- for XML input accord. to Menota -->
            <xsl:text>[ADD-ORIGINAL-NUMBER</xsl:text>
         
            <xsl:text>]</xsl:text>
        </xsl:if>
        
        <xsl:if test="self::w/parent::*[@xml:id=//ptr/@target/substring-after(., '#')]">    <!-- for XML input acc. to TEI -->
            <xsl:text>[</xsl:text>
            <xsl:value-of select="self::w/parent::*/attribute::xml:id"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:text> | </xsl:text>
        
         <!-- palaeographic annotation -->
            <xsl:if test="descendant::me:pal"><xsl:apply-templates select="descendant::me:pal"/></xsl:if>
        <xsl:if test="descendant::hi"><xsl:for-each select="descendant::hi/attribute::*"><xsl:value-of select="."/><xsl:text>¦</xsl:text></xsl:for-each></xsl:if>
        
        <!-- for Menota 3.0 encoded initials -->
        <xsl:if test="descendant::c">
            <xsl:choose>
                <xsl:when test="descendant::c/attribute::type='hyphen'"></xsl:when>
                <xsl:when test="descendant::c[attribute::type='initial']|descendant::c[attribute::type='noInitial']">
                    <xsl:for-each select="descendant::c[attribute::type='initial']|descendant::c[attribute::type='noInitial']">
                    <xsl:text>{l</xsl:text> <!-- print l with number(s) of which letterof the word is an initial -->
                    <xsl:choose>  
                                <xsl:when test="self::c[following-sibling::text()][not(preceding-sibling::c)]">
                                    <xsl:text>1</xsl:text>
                                    <xsl:if test="self::c/string-length() > 1">
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="self::c/string-length()"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="self::c[following-sibling::text()][preceding-sibling::c]">
                                    <xsl:value-of select="self::c/preceding-sibling::c/string-length() + 1"/>
                                    <xsl:if test="self::c/string-length() > 1">
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="self::c/string-length() + preceding-sibling::c/string-length()"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise><xsl:text>W</xsl:text></xsl:otherwise> <!-- for whole word -->
                    </xsl:choose>
                        
                        <!-- print colon + and type desgination-->
                        <xsl:text>:t</xsl:text>
                         <xsl:if test="self::c/attribute::type='initial'"><xsl:text>IN</xsl:text></xsl:if>
                        <xsl:if test="self::c/attribute::type='noInitial'"><xsl:text>NO</xsl:text></xsl:if>
                        
                        <!-- print subtype info -->
                        <xsl:if test="self::c/attribute::subtype">
                            <xsl:text> b</xsl:text>
                            <xsl:if test="self::c/attribute::subtype='opening'"><xsl:text>OP</xsl:text></xsl:if>
                            <xsl:if test="self::c/attribute::subtype='text'"><xsl:text>TE</xsl:text></xsl:if>
                            <xsl:if test="self::c/attribute::subtype='chapt'"><xsl:text>CH</xsl:text></xsl:if>
                            <xsl:if test="self::c/attribute::subtype='para'"><xsl:text>PA</xsl:text></xsl:if>
                            <xsl:if test="self::c/attribute::subtype='littNot'"><xsl:text>LI</xsl:text></xsl:if>
                        </xsl:if>
                        
                        <!-- print style info (as is) -->
                        <xsl:if test="self::c/attribute::style">
                            <xsl:text> </xsl:text><xsl:value-of select="self::c/attribute::style"/></xsl:if>
                        
                        <!-- print rend info -->
                        <xsl:if test="self::c/attribute::rend">
                            <xsl:variable name="IniRend" select="self::c/attribute::rend/translate(., ' ', '_')"/>
                            <xsl:text> r</xsl:text>
                            <xsl:variable name="IniRend_1" select="replace($IniRend, 'lombard', 'Lo')"/>
                            <xsl:variable name="IniRend_2" select="replace($IniRend_1, 'historiated', 'Hi')"/>
                            <xsl:variable name="IniRend_3" select="replace($IniRend_2, 'foliate', 'Fo')"/>
                            <xsl:variable name="IniRend_4" select="replace($IniRend_3, 'penFlourish', 'Pf')"/>
                            <xsl:variable name="IniRend_5" select="replace($IniRend_4, 'penwork', 'Pw')"/>
                            <xsl:variable name="IniRend_6" select="replace($IniRend_5, 'interlaced', 'Il')"/>
                            <xsl:variable name="IniRend_7" select="replace($IniRend_6, 'puzzle', 'Pu')"/>
                            <xsl:variable name="IniRend_8" select="replace($IniRend_7, 'zoomorphic', 'Zo')"/>
                            <xsl:variable name="IniRend_9" select="replace($IniRend_8, 'dragon', 'Dr')"/>
                            <xsl:variable name="IniRend_10" select="replace($IniRend_9, 'inhabited', 'Ih')"/>
                            <xsl:variable name="IniRend_11" select="replace($IniRend_10, 'versal', 'Ve')"/>
                            <xsl:variable name="IniRend_12" select="replace($IniRend_11, 'colourStroked', 'Cs')"/>
                            <xsl:variable name="IniRend_13" select="replace($IniRend_12, 'guideLetter', 'Gl')"/>
                            <xsl:variable name="IniRend_14" select="replace($IniRend_13, 'other', 'Ot')"/>
                            <xsl:value-of select="$IniRend_14"/>
                        </xsl:if>
                        
                    <xsl:text>}</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                
                <!-- for other usage of <c> -->
                <xsl:otherwise>
                    <xsl:for-each select="descendant::c/attribute::*"><xsl:value-of select="."/><xsl:text>¦</xsl:text></xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:if>
        
        
        <xsl:text> | </xsl:text>
        
         <!-- grapho-phonematic annotation -->
        <xsl:text> | </xsl:text>
        
        <xsl:choose>  <!-- notes -->
            <xsl:when test="descendant::note"><xsl:apply-templates select="descendant::note"/></xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- language code -->
          <xsl:choose>
              <xsl:when test="ancestor-or-self::*/attribute::xml:lang">   <!-- if xml:lang is specified on the ancestor div, seg or p or if a foreign is used -->
                  <xsl:value-of select="ancestor-or-self::*/attribute::xml:lang"/></xsl:when>
             <xsl:when test="ancestor::TEI/teiHeader/descendant::langUsage"> <!-- or grab language statement from header -->
                 <xsl:for-each select="ancestor::TEI/teiHeader/descendant::langUsage/language">
                      <xsl:value-of select="attribute::ident"/><xsl:text> </xsl:text></xsl:for-each>
              </xsl:when> 
          </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- extra column1 --> <!-- currently used for morpheme markup if present -->
        <xsl:choose>
            <xsl:when test="descendant::m">
                <xsl:for-each select="descendant::m">
                    <xsl:text>{</xsl:text>
                    <xsl:value-of select="self::m"/>
                   <xsl:if test="attribute::baseForm">
                       <xsl:text>:</xsl:text><xsl:value-of select="attribute::baseForm"/></xsl:if>
                       <xsl:if test="attribute::type">
                        <xsl:text>:</xsl:text><xsl:value-of select="attribute::type"/>
                    </xsl:if>
                    <xsl:text>}</xsl:text>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- extra column2 -->
        <xsl:text> | </xsl:text>
        
        <!-- spacing: add = or == for words that are written as one -->
        <xsl:if test="ancestor::seg[@type='nb']"><xsl:text>=</xsl:text>
        </xsl:if>
        <xsl:if test="ancestor::seg[@type='nb'] and preceding-sibling::w">
            <xsl:if test="position() = 2"><xsl:text>=</xsl:text></xsl:if>
            <xsl:if test="position() = 3"><xsl:text>==</xsl:text></xsl:if>
            <xsl:if test="position() = 4"><xsl:text>===</xsl:text></xsl:if>
            <xsl:if test="position() = 5"><xsl:text>====</xsl:text></xsl:if>
        </xsl:if>
        
        <xsl:if test="ancestor::seg[@type='enc']"><xsl:text>≠</xsl:text>
        </xsl:if>
        <xsl:if test="ancestor::seg[@type='enc'] and preceding-sibling::w">
            <xsl:if test="position() = 2"><xsl:text>≠</xsl:text></xsl:if>
            <xsl:if test="position() = 3"><xsl:text>≠≠</xsl:text></xsl:if>
            <xsl:if test="position() = 4"><xsl:text>≠≠≠</xsl:text></xsl:if>
            <xsl:if test="position() = 5"><xsl:text>≠≠≠≠</xsl:text></xsl:if>
        </xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- position in source (i.e. ref by fol. (potentially column)/line number) -->
        
        <xsl:choose>
            <xsl:when test="preceding::pb[not(attribute::ed)][1]/@n/string-length() = 2">  
                <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
            </xsl:when>
            <xsl:when test="preceding::pb[not(attribute::ed)][1]/@n/string-length() = 3">
                <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:otherwise>
                </xsl:choose>
        
        <xsl:if test="preceding::cb[not(attribute::ed)]"> <!-- insert letter from column break if present -->
            <xsl:value-of select="preceding::cb[not(attribute::ed)][1]/@n"/>
        </xsl:if>
        
        <xsl:text>-</xsl:text> <!-- separator -->
        
        <xsl:if test="ancestor::figure"><xsl:text>f</xsl:text></xsl:if> <!-- insert f if word is transcribed from illumination -->
        <xsl:if test="ancestor::add[descendant::lb]"><xsl:text>a</xsl:text></xsl:if> <!-- insert a if word is transcribed from illumination -->
        
        <xsl:choose>
             <xsl:when test="preceding::lb[not(attribute::ed)][1]/@n &lt; 10">  <!--  line number -->
                <xsl:text>0</xsl:text><xsl:value-of select="preceding::lb[not(attribute::ed)][1]/@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="preceding::lb[not(attribute::ed)][1]/@n"/>
            </xsl:otherwise>
        </xsl:choose> 
        
        <xsl:if test="self::w/descendant::lb[not(attribute::ed)]">  <!-- If the word in question is written over more than one line, get information on location of rest of word -->
                <!-- works with a maximum of 2 lines at the moment -->  
            <xsl:text>—</xsl:text>
            
            <xsl:choose>
                <xsl:when test="self::w/preceding::pb[not(attribute::ed)][1]/@n/string-length() = 2">   <!-- the previous pb is in front of word -->
                    <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:when test="self::w/preceding::pb[not(attribute::ed)][1]/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:when test="self::w/preceding::pb[not(attribute::ed)][1]/@n/string-length() = 4">
                    <xsl:value-of select="self::w/preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:when test="self::w/descendant::pb[not(attribute::ed)][1]/@n/string-length() = 2">  <!-- the previous pb is inside of word -->
                    <xsl:text>00</xsl:text><xsl:value-of select="descendant::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:when test="self::w/descendant::pb[not(attribute::ed)][1]/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="descendant::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:when test="self::w/descendant::pb[not(attribute::ed)][1]/@n/string-length() = 4">
                    <xsl:value-of select="self::w/descendant::pb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="self::w/preceding::pb[not(attribute::ed)][1]/@n"/>
                </xsl:otherwise>
            </xsl:choose>
            
           <xsl:choose> 
               <xsl:when test="self::w/descendant::cb[not(attribute::ed)]"> <!-- insert letter from column break if present -->
                   <xsl:value-of select="self::w/descendant::cb[not(attribute::ed)][1]/@n"/>
            </xsl:when>
               <xsl:when test="self::w/preceding::cb[not(attribute::ed)]">
                   <xsl:value-of select="self::w/preceding::cb[not(attribute::ed)][1]/@n"/>
               </xsl:when>
           </xsl:choose>
            
            <xsl:text>-</xsl:text> <!-- separator -->
            
            <xsl:choose>
                <xsl:when test="self::w/descendant::lb[not(attribute::ed)][1]/@n &lt; 10">  <!--  line number -->
                    <xsl:text>0</xsl:text><xsl:value-of select="self::w/descendant::lb[not(attribute::ed)][1]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="descendant::lb[not(attribute::ed)][1]/@n"/>
                </xsl:otherwise>
            </xsl:choose> 
            
        </xsl:if>
        <xsl:text> |</xsl:text>
        
            <xsl:text>&#x0a;</xsl:text> <!-- end of line -->
    </xsl:template>
    
    
    <!-- template to insert helping info for transposition when encoded acc. to Menota v.3.0 -->
    <xsl:template match="w[ancestor::orig[@rend]]">
        <xsl:text>ORDER OF WORDS PRIOR TO TRANSPOSITION:</xsl:text>
        <xsl:value-of select="descendant::me:norm"/><xsl:text> </xsl:text>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template> 
    
   
   
    
    <!-- template for pb, lb and cb (regular, i.e. not inside of a word) -->  
    <xsl:template match="pb[not(ancestor::w)]|lb[not(ancestor::w)]|cb[not(ancestor::w)]">
        <xsl:text>| </xsl:text>  <!-- beginning of line -->
        <xsl:choose> <!-- insert correct type desgination -->
            <xsl:when test="self::pb">
                <xsl:choose> 
                    <xsl:when test="@type='ed'"><xsl:text>pe</xsl:text></xsl:when><!-- pb in edition -->
                    <xsl:when test="@ed"><xsl:text>pe</xsl:text></xsl:when><!-- pb in edition (variant coding) -->
                    <xsl:otherwise><xsl:text>pm</xsl:text></xsl:otherwise> <!-- default: pb in manuscript -->
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::lb">
                <xsl:choose>
                    <xsl:when test="@type='ed'"><xsl:text>le</xsl:text></xsl:when><!-- lb in edition -->
                    <xsl:when test="@ed"><xsl:text>le</xsl:text></xsl:when><!-- lb in edition (variant coding) -->
                    <xsl:otherwise><xsl:text>lm</xsl:text></xsl:otherwise> <!-- default: lb in manuscript -->
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::cb">
                <xsl:choose>
                    <xsl:when test="@type='ed'"><xsl:text>ce</xsl:text></xsl:when><!-- cb in edition -->
                    <xsl:when test="@ed"><xsl:text>ce</xsl:text></xsl:when><!-- cb in edition (variant coding) -->
                    <xsl:otherwise><xsl:text>cm</xsl:text></xsl:otherwise> <!-- default: cb in manuscript -->
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text> 
        
           <!-- add fol./col/line number --> 
        <xsl:if test="self::pb"> <!--  fol. number -->
            <xsl:choose>
                <xsl:when test="self::pb/@n/string-length() = 1">  
                    <xsl:text>000</xsl:text><xsl:value-of select="self::pb/@n"/>
                </xsl:when>
                <xsl:when test="self::pb/@n/string-length() = 2">  
                    <xsl:text>00</xsl:text><xsl:value-of select="self::pb/@n"/>
                </xsl:when>
                <xsl:when test="self::pb/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="self::pb/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="self::pb/@n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <xsl:if test="self::lb[attribute::ed]|self::lb[attribute::type='ed']"><!-- line number edition--> 
            <xsl:choose>
                <xsl:when test="@n/string-length() = 1"> <!-- if the number of the line is one digit -->
                    <xsl:choose> <!-- grab previous pb from edition and prefix with right amount of 0s -->
                        <xsl:when test="preceding::pb[1][attribute::ed]/@n/string-length() = 2">  
                            <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[1][attribute::ed]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[1][attribute::type='ed']/@n/string-length() = 2">  
                            <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[1][attribute::type='ed']/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[1][attribute::ed]/@n/string-length() = 3">
                            <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[1][attribute::ed]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[1][attribute::type='ed']/@n/string-length() = 3">
                            <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[1][attribute::type='ed']/@n"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding::pb[1][attribute::ed or attribute::type='ed']/@n"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="preceding::cb[attribute::ed]|preceding::cb[attribute::type='ed']"> <!-- if cb marked up, add letter -->
                        <xsl:value-of select="preceding::cb[1][attribute::ed or attribute::type='ed']/@n"/>
                    </xsl:if>
                    
                    <!-- insert different correct separator for lb from edition -->
                  <xsl:text>.</xsl:text>
                    
                    <xsl:text>0</xsl:text><xsl:value-of select="@n"/> <!-- output line number with prefixed 0 -->
                </xsl:when>
                
            <xsl:otherwise> <!-- if line number is two digits -->
                <xsl:choose> <!-- input previous pb number -->
                    <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 1">  
                        <xsl:text>000</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                    </xsl:when>
                    <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 2">  
                        <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                    </xsl:when>
                    <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 3">
                        <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:if test="preceding::cb[attribute::ed]|preceding::cb[attribute::type='ed']"> <!-- if cb marked up, add letter -->
                    <xsl:value-of select="preceding::cb[attribute::ed or attribute::type='ed'][1]/@n"/>
                </xsl:if>
                
                <!-- insert different correct separator for lb from edition -->
                <xsl:text>.</xsl:text>
                
                <xsl:value-of select="@n"/> <!-- insert line number -->
            </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <xsl:if test="self::lb[not(attribute::ed) and not(attribute::type='ed')]"><!-- line number NOT edition (i.e. manuscript)-->
            
            <xsl:choose>
                <xsl:when test="@n/string-length() = 1"> <!-- if the number of the line is one digit -->
                    <xsl:choose> <!-- grab previous pb and prefix with right amount of 0s -->
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 1">  
                            <xsl:text>000</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 2">  
                            <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 3">
                            <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="preceding::cb[not(attribute::ed) and not(attribute::type='ed')]"> <!-- if cb marked up, add letter -->
                        <xsl:value-of select="preceding::cb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                    </xsl:if>
                    
                    <!-- insert correct separator for lb from the mansucript  -->
                    <xsl:text>-</xsl:text> 
                    
                    <xsl:text>0</xsl:text><xsl:value-of select="@n"/> <!-- output line number with prefixed 0 -->
                </xsl:when>
                
                <xsl:otherwise> <!-- if line number is two digits -->
                    <xsl:choose> <!-- input previous pb number -->
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 1">  
                            <xsl:text>000</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 2">  
                            <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 3">
                            <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="preceding::cb"> <!-- if cb marked up, add letter -->
                        <xsl:value-of select="preceding::cb[1]/@n"/>
                    </xsl:if>
                    
                    <!-- insert correct separator for the lb from mansucript  -->
                   <xsl:text>-</xsl:text>
                    
                    <xsl:value-of select="@n"/> <!-- insert line number -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <xsl:if test="self::cb[not(attribute::ed) and not(attribute::type='ed')]"> <!-- for cb (not edition)--> 
            <xsl:choose> <!-- input previous pb number -->
                <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 1">  
                    <xsl:text>000</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                </xsl:when>
                <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 2">  
                    <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                </xsl:when>
                <xsl:when test="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="preceding::pb[not(attribute::ed) and not(attribute::type='ed')][1]/@n"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- insert correct separator for cb in mansucript -->
         <xsl:text>-</xsl:text> 
            <!-- insert letter -->
          <xsl:value-of select="@n"/>
        </xsl:if>
        
        <xsl:if test="self::cb[attribute::ed or attribute::type='ed']"> <!-- for cb in edition --> 
            <xsl:choose> <!-- input previous pb number -->
                <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 1">  
                    <xsl:text>000</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                </xsl:when>
                <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 2">  
                    <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                </xsl:when>
                <xsl:when test="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="preceding::pb[attribute::ed or attribute::type='ed'][1]/@n"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- insert correct separator for cb in edition -->
           <xsl:text>.</xsl:text>
            <!-- insert letter -->
            <xsl:value-of select="@n"/>
        </xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add @facs info -->
        <xsl:if test="attribute::facs"><xsl:value-of select="attribute::facs"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add @rend info -->
        <xsl:if test="attribute::rend"><xsl:value-of select="attribute::rend"/></xsl:if>
        
        <!--  empty fields -->
        <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  | </xsl:text> 
        
        <xsl:text> |&#x0a;</xsl:text> <!-- end of line-->
    </xsl:template>
    
    
    <!-- template for gb and handShift, space (regular, i.e. not inside of a word), metamark (when not part of tranposition) and gap (when neither part of a word not containing words)-->  
    <xsl:template match="gb[not(ancestor::w)]|handShift[not(ancestor::w)]|space[not(ancestor::w)]|metamark[not(@function='transposition')]|gap[not(ancestor::w or descendant::w)]">
        <xsl:text>| </xsl:text>  <!-- beginning of line -->
        <xsl:choose> <!-- insert correct type desgination -->
            <xsl:when test="self::gb"><xsl:text>bg</xsl:text></xsl:when>
            <xsl:when test="self::handShift"><xsl:text>hs</xsl:text></xsl:when>
            <xsl:when test="self::space"><xsl:text>sp</xsl:text></xsl:when>
            <xsl:when test="self::metamark[not(@function='transposition')]"><xsl:text>mm</xsl:text></xsl:when>
            <xsl:when test="self::gap"><xsl:text>ga</xsl:text></xsl:when>
        </xsl:choose>
        
        <xsl:text> | </xsl:text> 
        <!-- empty field for "X" if these elements occur within a word -->
        <xsl:text> | </xsl:text> 
        
        <!-- add number for gb --> 
            <xsl:if test="self::gb"><xsl:value-of select="attribute::n"/></xsl:if>
        <!-- add ID for handShift (@new) --> 
            <xsl:if test="self::handShift"><xsl:value-of select="attribute::new"/></xsl:if>
        <!-- add vertical extent for space and potentially unit -->
        <xsl:if test="self::space">
            <xsl:choose>
            <xsl:when test="attribute::quantity"><xsl:value-of select="attribute::quantity"/></xsl:when>
            <xsl:when test="attribute::extent"><xsl:value-of select="attribute::extent"/></xsl:when>
        </xsl:choose>
                <xsl:if test="attribute::unit"><xsl:text>_</xsl:text><xsl:value-of select="attribute::unit"/></xsl:if></xsl:if>
        <!-- for metamark get @function -->
        <xsl:if test="self::metamark[not(@function='transposition')]"><xsl:value-of select="attribute::function"/></xsl:if>
        <!-- for gap get extent of gap and potentially unit -->
        <xsl:if test="self::gap">
            <xsl:choose>
                <xsl:when test="attribute::quantity"><xsl:value-of select="."/></xsl:when>
                <xsl:when test="attribute::extent"><xsl:value-of select="."/></xsl:when>
            </xsl:choose>
            <xsl:if test="attribute::unit"><xsl:text>_</xsl:text><xsl:value-of select="attribute::unit"/></xsl:if></xsl:if>
        
        <xsl:text> | </xsl:text>
        
        <!-- for space get value of @dim, i.e. horizontal or vertical -->
        <xsl:if test="self::space"><xsl:value-of select="attribute::dim"/></xsl:if>
        <!-- for metamark get @target -->
        <xsl:if test="self::metamark[not(@function='transposition')]"><xsl:value-of select="attribute::target"/></xsl:if>
        <!-- for gap get @reason -->
        <xsl:if test="self::gap"><xsl:value-of select="attribute::reason"/></xsl:if>
        
        <xsl:text> | </xsl:text>
        
        <!-- for metamark get @rend -->
        <xsl:if test="self::metamark[not(@function='transposition')]"><xsl:value-of select="attribute::rend"/></xsl:if>
        <!-- for gap get @agent -->
        <xsl:if test="self::gap"><xsl:value-of select="attribute::agent"/></xsl:if>
        
        <xsl:text> | </xsl:text>
        
        <!-- for gap get @resp -->
        <xsl:if test="self::gap"><xsl:value-of select="attribute::resp"/></xsl:if>
        <!-- for space get @resp -->
        <xsl:if test="self::space"><xsl:value-of select="attribute::resp"/></xsl:if>
        <!-- for metamark get @ana -->
        <xsl:if test="self::metamark[not(@function='transposition')]"><xsl:value-of select="attribute::ana"/></xsl:if>
        
        <xsl:text> | </xsl:text>
        <!-- for metamark get contained text -->
        <xsl:if test="self::metamark[not(@function='transposition')]"><xsl:value-of select="descendant-or-self::text()"/></xsl:if>
        
        <xsl:text> | </xsl:text>
        <!-- for metamark get contained elements and potential attribute with their values (separated by broken pipe) -->
        <xsl:if test="self::metamark[not(@function='transposition')]/descendant::*"><xsl:for-each select="descendant::*">
            <xsl:value-of select="name(.)"/>
            <xsl:if test="attribute::*"><xsl:text>_</xsl:text><xsl:value-of select="attribute::*/local-name()"/><xsl:text>=</xsl:text><xsl:value-of select="attribute::*"/></xsl:if>
            <xsl:text>¦</xsl:text>
        </xsl:for-each></xsl:if>
        
        <xsl:text> | </xsl:text>
        <!--  empty fields -->
        <xsl:text> |  |  |  |  |  |  |  | </xsl:text> 
        
        <xsl:text> |&#x0a;</xsl:text> <!-- end of line-->
    </xsl:template>
    
        
    <!-- Beginning/end lines for names -->
    
    <xsl:template match="persName|placeName|name|forename|surname|roleName|addName"> 
       <xsl:choose><!-- don't add any extra markup when additional name element contained, i.e. expected that when an ancestor naming element is present as a wrapper
           all relevant names inside it are enclosed by another naming element (and all on same level of nesting) -->
           <xsl:when test="self::name[descendant::forename]|self::persName[descendant::forename]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::surename]|self::persName[descendant::surename]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::roleName]|self::persName[descendant::roleName]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::addName]|self::persName[descendant::addName]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::persName]|self::persName[descendant::persName]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::placeName]|self::persName[descendant::placeName]"><xsl:apply-templates/></xsl:when>
           <xsl:when test="self::name[descendant::nameLink]|self::persName[descendant::nameLink]"><xsl:apply-templates/></xsl:when>
           
      <xsl:otherwise> <!-- when self is the innermost naming element, then add a line -->
        <xsl:text>| </xsl:text>         <!-- beginning line -->
        <xsl:choose> <!-- insert correct type designation -->
            <xsl:when test="self::persName|self::name[@type='person']"><xsl:text>PE</xsl:text></xsl:when>
            <xsl:when test="self::forename|self::surname|self::addName|self::roleName|self::nameLink"><xsl:text>PE</xsl:text></xsl:when>
            <xsl:when test="self::placeName|self::name[@type='place']"><xsl:text>PL</xsl:text></xsl:when>
            <xsl:when test="self::name[@type/starts-with(.,'org')]"><xsl:text>OR</xsl:text></xsl:when><!-- new tag! -->
        </xsl:choose>
        <xsl:text> | b | </xsl:text>  <!-- beginning tag -->
        
        <!-- add ID (if encoded)-->
        <xsl:choose>
            <!-- from self if encoded -->
                <xsl:when test="attribute::key"><xsl:value-of select="attribute::key"/></xsl:when> 
            <xsl:when test="attribute::me:key"><xsl:value-of select="attribute::me:key"/></xsl:when>
            <xsl:when test="attribute::ref"><xsl:value-of select="attribute::ref"/></xsl:when>
            <xsl:when test="attribute::me:ref"><xsl:value-of select="attribute::me:ref"/></xsl:when>
            <!-- get ID from ancestor name element if only present there -->
            <xsl:when test="ancestor::name/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
            <xsl:when test="ancestor::persName/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
            <xsl:when test="ancestor::placeName/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
            <xsl:when test="ancestor::name/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when>
            <xsl:when test="ancestor::persName/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when>
            <xsl:when test="ancestor::placeName/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when> 
            <xsl:when test="ancestor::name/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
            <xsl:when test="ancestor::persName/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
            <xsl:when test="ancestor::placeName/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
            <xsl:when test="ancestor::name/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
            <xsl:when test="ancestor::persName/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
            <xsl:when test="ancestor::placeName/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <xsl:choose>
            <!-- add type for personal names -->
            <xsl:when test="self::forename|self::persName[@type='forename']|self::name[@type='person'][@subtype='forename']"><xsl:text>forename</xsl:text></xsl:when>
            <xsl:when test="self::surname|self::persName[@type='surname']|self::name[@type='person'][@subtype='surname']"><xsl:text>surname</xsl:text></xsl:when>
            <xsl:when test="self::roleName[not(@type)]|self::persName[@type='roleName']|self::name[@type='person'][@subtype='roleName']"><xsl:text>roleName</xsl:text></xsl:when>
            <xsl:when test="self::addName[@type]"><xsl:value-of select="self::addName/@type"/></xsl:when>
            <xsl:when test="self::addName[@type='namelink']|self::nameLink"><xsl:text>nameLink</xsl:text></xsl:when>
            <xsl:when test="self::roleName[@type]"><xsl:value-of select="self::roleName/@type"/></xsl:when>
            <!-- leave field empty for placename or organization -->
            <xsl:when test="self::placeName|self::name[@type/starts-with(., 'org')]"></xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text> 
          
          <!-- insert name part counter if self is descendant of another name element linking it together -->
          <xsl:if test="ancestor::name|ancestor::persName|ancestor::placeName">
              <xsl:choose>
                  <xsl:when test="self::*[not(preceding-sibling::persName or preceding-sibling::name or preceding-sibling::forename or preceding-sibling::surname or
                      preceding-sibling::addName or preceding-sibling::roleName)]">
                      <xsl:text>np1</xsl:text>
                  </xsl:when>
                  <xsl:when test="self::*[preceding-sibling::persName or preceding-sibling::name or preceding-sibling::forename or preceding-sibling::surname or
                      preceding-sibling::addName or preceding-sibling::roleName]">
                      <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 1">
                          <xsl:text>np2</xsl:text>
                      </xsl:if>
                      <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 2">
                          <xsl:text>np3</xsl:text>
                      </xsl:if>
                      <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 3">
                          <xsl:text>np4</xsl:text>
                      </xsl:if>
                  </xsl:when>
              </xsl:choose>
          </xsl:if>
          <xsl:text> | </xsl:text> 
          
          <!--  empty fields -->
          <xsl:text> |  |  |  |  |  |  |  |  |  |  |  | </xsl:text> 
        
        <xsl:text> |&#x0a;</xsl:text> <!-- end of beginning line-->
        
        <xsl:apply-templates/> <!-- process everything in between, i.e. enclosed w, pc, etc. -->
        
        <xsl:text>| </xsl:text> <!--  closing line -->
            <xsl:choose>
                <xsl:when test="self::persName|self::name[@type='person']"><xsl:text>PE</xsl:text></xsl:when>
                <xsl:when test="self::forename|self::surname|self::addName|self::roleName|self::nameLink"><xsl:text>PE</xsl:text></xsl:when>
                <xsl:when test="self::placeName|self::name[@type='place']"><xsl:text>PL</xsl:text></xsl:when>
                <xsl:when test="self::name[@type/starts-with(.,'org')]"><xsl:text>OR</xsl:text></xsl:when><!-- new tag! -->
            </xsl:choose>
        
        <xsl:text> | e |</xsl:text> <!-- end tag -->
        
          <!-- add ID (if encoded)-->
          <xsl:choose>
              <!-- from self if encoded -->
              <xsl:when test="attribute::key"><xsl:value-of select="attribute::key"/></xsl:when> 
              <xsl:when test="attribute::me:key"><xsl:value-of select="attribute::me:key"/></xsl:when>
              <xsl:when test="attribute::ref"><xsl:value-of select="attribute::ref"/></xsl:when>
              <xsl:when test="attribute::me:ref"><xsl:value-of select="attribute::me:ref"/></xsl:when>
              <!-- get ID from ancestor name element if only present there -->
              <xsl:when test="ancestor::name/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
              <xsl:when test="ancestor::persName/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
              <xsl:when test="ancestor::placeName/attribute::key"><xsl:value-of select="ancestor::name/attribute::key"/></xsl:when>
              <xsl:when test="ancestor::name/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when>
              <xsl:when test="ancestor::persName/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when>
              <xsl:when test="ancestor::placeName/attribute::me:key"><xsl:value-of select="ancestor::name/attribute::me:key"/></xsl:when> 
              <xsl:when test="ancestor::name/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
              <xsl:when test="ancestor::persName/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
              <xsl:when test="ancestor::placeName/attribute::ref"><xsl:value-of select="ancestor::name/attribute::ref"/></xsl:when>
              <xsl:when test="ancestor::name/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
              <xsl:when test="ancestor::persName/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
              <xsl:when test="ancestor::placeName/attribute::me:ref"><xsl:value-of select="ancestor::name/attribute::me:ref"/></xsl:when>
              <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
          <xsl:text> | </xsl:text>
          
          <xsl:choose>
              <!-- add type for personal names -->
              <xsl:when test="self::forename|self::persName[@type='forename']|self::name[@type='person'][@subtype='forename']"><xsl:text>forename</xsl:text></xsl:when>
              <xsl:when test="self::surname|self::persName[@type='surname']|self::name[@type='person'][@subtype='surname']"><xsl:text>surname</xsl:text></xsl:when>
              <xsl:when test="self::roleName[not(@type)]|self::persName[@type='roleName']|self::name[@type='person'][@subtype='roleName']"><xsl:text>roleName</xsl:text></xsl:when>
              <xsl:when test="self::addName[@type]"><xsl:value-of select="self::addName/@type"/></xsl:when>
              <xsl:when test="self::addName[@type='namelink']|self::nameLink"><xsl:text>nameLink</xsl:text></xsl:when>
              <xsl:when test="self::roleName[@type]"><xsl:value-of select="self::roleName/@type"/></xsl:when>
              <!-- leave field empty for placename or organization -->
              <xsl:when test="self::placeName|self::name[@type/starts-with(., 'org')]"></xsl:when>
          </xsl:choose>
        <xsl:text> | </xsl:text> 
       
       <!-- insert name part counter if self is descendant of another name element linking it together -->
       <xsl:if test="ancestor::name|ancestor::persName|ancestor::placeName">
           <xsl:choose>
               <xsl:when test="self::*[not(preceding-sibling::persName or preceding-sibling::name or preceding-sibling::forename or preceding-sibling::surname or
                   preceding-sibling::addName or preceding-sibling::roleName)]">
                   <xsl:text>np1</xsl:text>
               </xsl:when>
               <xsl:when test="self::*[preceding-sibling::persName or preceding-sibling::name or preceding-sibling::forename or preceding-sibling::surname or
                   preceding-sibling::addName or preceding-sibling::roleName]">
                   <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 1">
                       <xsl:text>np2</xsl:text>
                   </xsl:if>
                   <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 2">
                       <xsl:text>np3</xsl:text>
                   </xsl:if>
                   <xsl:if test="count(preceding-sibling::persName|preceding-sibling::name|preceding-sibling::forename|preceding-sibling::surname|preceding-sibling::addName|preceding-sibling::roleName) = 3">
                       <xsl:text>np4</xsl:text>
                   </xsl:if>
               </xsl:when>
           </xsl:choose>
       </xsl:if>
          <xsl:text> | </xsl:text> 
          
          <!--  empty fields -->
          <xsl:text> |  |  |  |  |  |  |  |  |  |  |  | </xsl:text> 
        
        <xsl:text> |&#x0a;</xsl:text> <!-- end of ending line-->
          
      </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    
    
    <!-- beginning/end lines for structural markup (not names, not for emmendations or editorial markup) -->
    <xsl:template match="div|head|p|seg|lg|l|s">  
        <xsl:text>| </xsl:text>         <!-- beginning line -->
        <xsl:choose><!-- insert correct type -->
            <xsl:when test="self::div"><xsl:text>d</xsl:text></xsl:when>
            <xsl:when test="self::head"><xsl:text>h</xsl:text></xsl:when>
            <xsl:when test="self::p"><xsl:text>pa</xsl:text></xsl:when>
            <xsl:when test="self::seg"><xsl:text>sg</xsl:text></xsl:when>    <!-- new: 5/7 2019: <seg> is translated into sg, while <s> is s -->
            <xsl:when test="self::lg"><xsl:text>lg</xsl:text></xsl:when>
            <xsl:when test="self::l"><xsl:text>l</xsl:text></xsl:when>
            <xsl:when test="self::s"><xsl:text>s</xsl:text></xsl:when>
        </xsl:choose>
        <xsl:text> | b | </xsl:text>  <!-- beginning tag -->
        
        <!-- internal counter -->
        <xsl:choose>
            <xsl:when test="self::div"><xsl:number format="1" from="body" level="any" count="//div[parent::div]"/></xsl:when> <!-- does not count outer <div>, which is used for generating sections -->
            <xsl:when test="self::head"><xsl:number format="1" from="body" level="any" count="//head"/></xsl:when>
            <xsl:when test="self::p"><xsl:number format="1" from="body" level="any" count="//p"/></xsl:when>
            <xsl:when test="self::seg"><xsl:number format="1" from="body" level="any" count="//seg"/></xsl:when>
            <xsl:when test="self::lg"><xsl:number format="1" from="body" level="any" count="//lg"/></xsl:when>
            <xsl:when test="self::l"><xsl:number format="1" from="body" level="any" count="//l"/></xsl:when>
            <xsl:when test="self::s"><xsl:number format="1" from="body" level="any" count="//s"/></xsl:when>
        </xsl:choose>
        
        <!-- not in use! -->
        <!-- for l get @n attribute of ancestor lg and add its own @n -->
        <!--  <xsl:if test="self::l"><xsl:value-of select="ancestor::lg/attribute::n"/><xsl:text>-</xsl:text><xsl:value-of select="attribute::n"/></xsl:if> -->
        <xsl:text> | </xsl:text>
        
        <!-- add value of @n-->
        <xsl:if test="attribute::n"><xsl:value-of select="attribute::n"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @type-->
            <xsl:if test="attribute::type"><xsl:value-of select="attribute::type"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @subtype-->
        <xsl:if test="attribute::subtype"><xsl:value-of select="attribute::subtype"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @xml:id--> 
        <xsl:if test="attribute::xml:id"><xsl:value-of select="attribute::xml:id"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @rend-->
        <xsl:if test="attribute::rend"><xsl:value-of select="attribute::rend"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @met-->
        <xsl:if test="attribute::met"><xsl:value-of select="attribute::met"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @real-->
        <xsl:if test="attribute::real"><xsl:value-of select="attribute::real"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @rhyme-->
        <xsl:if test="attribute::rhyme"><xsl:value-of select="attribute::rhyme"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- not in use -->
        <!-- retrieve other text --> 
        <!-- <xsl:if test="self::*/text()[not(ancestor::w or ancestor::pc or ancestor::me:punct)]"><xsl:value-of select="."/></xsl:if> -->
        <xsl:text> | </xsl:text> 
        
        <!-- empty fields -->
        <xsl:text> |  |  |  | </xsl:text>
        
        <xsl:text> | &#x0a;</xsl:text> <!-- close beginning line-->
        
        <xsl:apply-templates/> <!-- process everything in between, i.e. enclosed w, pc, etc. -->
        
        <xsl:text>| </xsl:text> <!--  ending line -->
        <xsl:choose>
            <xsl:when test="self::div"><xsl:text>d</xsl:text></xsl:when>
            <xsl:when test="self::head"><xsl:text>h</xsl:text></xsl:when>
            <xsl:when test="self::p"><xsl:text>pa</xsl:text></xsl:when>
            <xsl:when test="self::seg"><xsl:text>sg</xsl:text></xsl:when> <!-- new: 5/7 2019: <seg> is translated into sg, while <s> is s -->
            <xsl:when test="self::lg"><xsl:text>lg</xsl:text></xsl:when>
            <xsl:when test="self::l"><xsl:text>l</xsl:text></xsl:when>
            <xsl:when test="self::s"><xsl:text>s</xsl:text></xsl:when>
        </xsl:choose>
        <xsl:text> | e | </xsl:text> 
        
        <!-- internal counter -->
        <xsl:choose>
            <xsl:when test="self::div"><xsl:number format="1" from="body" level="any" count="//div[parent::div]"/></xsl:when>  <!-- does not count outer <div>, which is used for generating sections -->
            <xsl:when test="self::head"><xsl:number format="1" from="body" level="any" count="//head"/></xsl:when>
            <xsl:when test="self::p"><xsl:number format="1" from="body" level="any" count="//p"/></xsl:when>
            <xsl:when test="self::seg"><xsl:number format="1" from="body" level="any" count="//seg"/></xsl:when>
            <xsl:when test="self::lg"><xsl:number format="1" from="body" level="any" count="//lg"/></xsl:when>
            <xsl:when test="self::l"><xsl:number format="1" from="body" level="any" count="//l"/></xsl:when>
            <xsl:when test="self::s"><xsl:number format="1" from="body" level="any" count="//s"/></xsl:when>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- empty fields -->
     <xsl:text>  |  |  |  |  |  |  |  |  |  |  |  | </xsl:text>
        
        <xsl:text> |&#x0a;</xsl:text> <!-- close tag-->
        
    </xsl:template>
    
    
    
    <!-- beginning/end lines for figures (i.e. illumination that are not initials) -->
    <xsl:template match="figure">  
        <xsl:text>| fi</xsl:text>         <!-- beginning line -->
       
        <xsl:text> | b | </xsl:text>  <!-- beginning tag -->
        
        <!-- internal counter -->
      <xsl:number format="1" from="body" level="any" count="//figure"/>
       <xsl:text> | </xsl:text>
        
        <!-- add value of @n-->
        <xsl:if test="attribute::n"><xsl:value-of select="attribute::n"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add contents of descending <head>-->
        <xsl:if test="descendant::head"><xsl:value-of select="descendant::head"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- space for Iconclass number-->
        <xsl:text> | </xsl:text>
        
        <!-- space for colours --> 
         <xsl:text> | </xsl:text>
        
        <!-- space for artistic technique -->
        <xsl:text> | </xsl:text>
        
        <!-- space for info on artist -->
        <xsl:text> | </xsl:text>
        
        <!-- empty fields -->
        <xsl:text> |  |  |  |  |  |  | </xsl:text> 
        
       <!-- add location (fol. and potentially column) -->
        <xsl:choose>
            <xsl:when test="preceding::pb[not(attribute::ed)][1]/@n/string-length() = 2">  
                <xsl:text>00</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
            </xsl:when>
            <xsl:when test="preceding::pb[not(attribute::ed)][1]/@n/string-length() = 3">
                <xsl:text>0</xsl:text><xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="preceding::pb[not(attribute::ed)][1]/@n"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="preceding::cb[not(attribute::ed)]"> <!-- insert letter from column break if present -->
            <xsl:value-of select="preceding::cb[not(attribute::ed)][1]/@n"/>
        </xsl:if>
        
        <xsl:if test="descendant::pb"> <!-- insert additional location info if figure exentends over more than one page (and potentially column) -->
            <xsl:text>—</xsl:text>
            <xsl:choose>
                <xsl:when test="descendant::pb[not(attribute::ed)][1]/@n/string-length() = 2">  
                    <xsl:text>00</xsl:text><xsl:value-of select="descendant::pb[not(attribute::ed)]/@n"/>
                </xsl:when>
                <xsl:when test="descendant::pb[not(attribute::ed)][1]/@n/string-length() = 3">
                    <xsl:text>0</xsl:text><xsl:value-of select="descendant::pb[not(attribute::ed)]/@n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="descendant::pb[not(attribute::ed)]/@n"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="descendant::cb[not(attribute::ed)]"> <!-- insert letter from column break if present -->
                <xsl:value-of select="descendant::cb[not(attribute::ed)]/@n"/>
            </xsl:if>
            
        </xsl:if>
        
        <xsl:if test="descendant::cb[not(attribute::ed)][not(ancestor::figure/descendant::pb)]"> <!-- insert letter from column break if no pb present in figure -->
            <xsl:text>—</xsl:text>
            <xsl:value-of select="descendant::cb[not(attribute::ed)]/@n"/>
        </xsl:if>
        
        <xsl:text> | &#x0a;</xsl:text> <!-- close beginning line-->
        
        <xsl:apply-templates/> <!-- process everything in between, i.e. enclosed w, pc, etc. -->
        
        <xsl:text>| fi</xsl:text> <!--  ending line -->
        
        <xsl:text> | e | </xsl:text> 
        
        <!-- internal counter -->
        <xsl:number format="1" from="body" level="any" count="//figure"/>
        
        <xsl:text> | </xsl:text>
        
        <!-- empty fields -->
        <xsl:text>  |  |  |  |  |  |  |  |  |  |  |  | </xsl:text>
        
        <xsl:text> |&#x0a;</xsl:text> <!-- close tag-->
        
    </xsl:template>
    
    
      
    <!-- beginning/end lines for editorial markup (not within words), quote/q, forme work and for transposition of entire words (when encoded acc. to Menota v. 3.0) -->
    <xsl:template match="add[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|del[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|supplied[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|me:suppressed[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|surplus[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|me:expunged[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|unclear[not(ancestor::w or ancestor::num or ancestor::pc or ancestor::me:punct)]|quote|q|fw|reg[@type='transposition']"> 
        <!-- OBS: because all <w>s within <orig> are suppressed for coding of transposition acc. to Menota, this causes the word count to be off and it has to be adjusted in eLisp -->
        
        <xsl:text>| </xsl:text>         <!-- beginning line -->
        <xsl:choose><!-- insert correct type desgination -->
            <xsl:when test="self::add"><xsl:text>ad</xsl:text></xsl:when>
            <xsl:when test="self::del"><xsl:text>de</xsl:text></xsl:when>
            <xsl:when test="self::supplied"><xsl:text>su</xsl:text></xsl:when>
            <xsl:when test="self::me:suppressed|self::surplus|self::me:expunged"><xsl:text>sd</xsl:text></xsl:when>
            <xsl:when test="self::unclear"><xsl:text>uc</xsl:text></xsl:when>
            <xsl:when test="self::quote|self::q">q</xsl:when>
            <xsl:when test="self::fw">fw</xsl:when>
            <xsl:when test="self::reg[@type='transposition']">ts</xsl:when> <!-- for transposition (in Menotic XML). The corrected order is printed -->
           </xsl:choose>
        <xsl:text> | b | </xsl:text>  <!-- beginning tag -->
        
        <!--Add internal counter-->
        <xsl:choose>
            <xsl:when test="self::add"><xsl:number format="1" from="body" level="any" count="//add[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::del"><xsl:number format="1" from="body" level="any" count="//del[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::supplied"><xsl:number format="1" from="body" level="any" count="//supplied[not(ancestor::w or ancestor::pc or ancestor::me:punct or ancestor::num)]"/></xsl:when>
            <xsl:when test="self::me:suppressed"><xsl:number format="1" from="body" level="any" count="//me:suppressed[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::me:expunged"><xsl:number format="1" from="body" level="any" count="//me:expunged[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::surplus"><xsl:number format="1" from="body" level="any" count="//ssurplus[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::unclear"><xsl:number format="1" from="body" level="any" count="//unclear[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::quote"><xsl:number format="1" from="body" level="any" count="//quote"/></xsl:when>
            <xsl:when test="self::q"><xsl:number format="1" from="body" level="any" count="//q"/></xsl:when>
            <xsl:when test="self::fw"><xsl:number format="1" from="body" level="any" count="//fw"/></xsl:when>
        <!--    <xsl:when test="self::reg[@type='transposition']"><xsl:number format="1" from="body" level="any" count="//reg[@type='transposition']"/></xsl:when> --> <!-- not part of Rasmus Bjørn's encoding practice -->
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @type (except for transpositions)-->
        <xsl:choose>
            <xsl:when test="self::reg[@type='transposition']"></xsl:when>
            <xsl:otherwise><xsl:if test="attribute::type"><xsl:value-of select="attribute::type"/></xsl:if></xsl:otherwise>
        </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @reason-->
        <xsl:if test="attribute::reason"><xsl:value-of select="attribute::reason"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @resp-->
        <xsl:if test="attribute::resp"><xsl:value-of select="attribute::resp"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @hand-->
        <xsl:if test="attribute::hand"><xsl:value-of select="attribute::hand"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @rend-->
        <xsl:if test="attribute::rend"><xsl:value-of select="attribute::rend"/></xsl:if>
        <xsl:if test="self::reg[@type='transposition']"><xsl:value-of select="parent::choice/child::orig/@rend"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @place-->
        <xsl:if test="attribute::place"><xsl:value-of select="attribute::place"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @agent-->
        <xsl:if test="attribute::agent"><xsl:value-of select="attribute::agent"/></xsl:if>
        <xsl:text> | </xsl:text>
        
        <!-- add value of @source-->
        <xsl:if test="attribute::source"><xsl:value-of select="attribute::source"/></xsl:if>
        <xsl:text> | </xsl:text>
     
        <!-- empty fields  -->
        <xsl:text>  |  |  |  |  |  </xsl:text>
        
        <xsl:text> | &#x0a;</xsl:text> <!-- close beginning line-->
        
        <xsl:apply-templates/> <!-- process everything in between, i.e. enclosed w --> 
        
        <xsl:text> | </xsl:text> <!--  ending line -->
        <xsl:choose><!-- insert correct type desgination -->
            <xsl:when test="self::add"><xsl:text>ad</xsl:text></xsl:when>
            <xsl:when test="self::del"><xsl:text>de</xsl:text></xsl:when>
            <xsl:when test="self::supplied"><xsl:text>su</xsl:text></xsl:when>
            <xsl:when test="self::me:suppressed|self::surplus|self::me:expunged"><xsl:text>sd</xsl:text></xsl:when>
            <xsl:when test="self::unclear"><xsl:text>uc</xsl:text></xsl:when>
            <xsl:when test="self::quote|self::q"><xsl:text>q</xsl:text></xsl:when>
            <xsl:when test="self::fw"><xsl:text>fw</xsl:text></xsl:when>
            <xsl:when test="self::reg[@type='transposition']">ts</xsl:when> <!-- for transposition (in Menotic XML). -->
            </xsl:choose>
        <xsl:text> | e | </xsl:text>  <!-- end tag -->
        
        <!--Add internal counter?-->
        <xsl:choose>
            <xsl:when test="self::add"><xsl:number format="1" from="body" level="any" count="//add[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::del"><xsl:number format="1" from="body" level="any" count="//del[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::supplied"><xsl:number format="1" from="body" level="any" count="//supplied[not(ancestor::w or ancestor::pc or ancestor::me:punct or ancestor::num)]"/></xsl:when>
            <xsl:when test="self::me:suppressed"><xsl:number format="1" from="body" level="any" count="//me:suppressed[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::me:expunged"><xsl:number format="1" from="body" level="any" count="//me:expunged[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::surplus"><xsl:number format="1" from="body" level="any" count="//ssurplus[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::unclear"><xsl:number format="1" from="body" level="any" count="//unclear[not(ancestor::w)]"/></xsl:when>
            <xsl:when test="self::quote"><xsl:number format="1" from="body" level="any" count="//quote"/></xsl:when>
            <xsl:when test="self::q"><xsl:number format="1" from="body" level="any" count="//q"/></xsl:when>
            <xsl:when test="self::fw"><xsl:number format="1" from="body" level="any" count="//fw"/></xsl:when>
          <!--  <xsl:when test="self::reg[@type='transposition']"><xsl:number format="1" from="body" level="any" count="//reg[@type='transposition']"/></xsl:when> -->
               </xsl:choose>
        <xsl:text> | </xsl:text>
        
        <!-- empty fields-->
        <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  | </xsl:text>
        
        <xsl:text> | &#x0a;</xsl:text> <!-- close line-->
          
    </xsl:template>
    
    
    <!-- beginning/end lines for transposition of entire words when encoded according to TEI. OBS! All words in a reordered sequence need to be inlcuded in element of same name and re-ordered in the <transpose> element-->
    <xsl:template match="*[@xml:id=//ptr/@target/substring-after(., '#')]">
        
        <xsl:choose>
            <xsl:when test="self::*[@xml:id=//ptr/@target/substring-after(., '#')]/not(preceding-sibling::*[@xml:id=//ptr/@target/substring-after(., '#')][1])">
                <xsl:variable name="local-transposition-ID" select="self::*/attribute::xml:id"/>
                
                <xsl:for-each select="//transpose[descendant::ptr/@target/substring-after(., '#') = $local-transposition-ID]/child::ptr">
                    <xsl:text>DESIRED ORDER OF WORDS ACCORDING TO TRANSPOSITION: </xsl:text>
                    <xsl:value-of select="attribute::target/substring-after(.,'#')"/>
                    <xsl:text>&#x0a;</xsl:text>
                </xsl:for-each>
                
               
                <xsl:text>| ts | b | </xsl:text>  <!-- beginning tag -->
                
                
                <!--empty fields-->
                <xsl:text> |  |  |  | </xsl:text>
                
                <!-- add value of @resp on metamark (i.e. which hand was responsible for the mark)-->
                <xsl:if test="child::metamark[@function='transposition']/@resp"><xsl:value-of select="child::metamark[@function='transposition']/@resp"/></xsl:if>
                <xsl:text> | </xsl:text>
                
                <!-- read in the transposition signs -->
                <xsl:if test="child::metamark[@function='transposition']">
                    <xsl:value-of select="child::metamark[@function='transposition']"/>
                    <xsl:if test="following-sibling::*[@xml:id=//ptr/@target/substring-after(., '#')][child::metamark]"> <!-- if further metamarks are present, read in, preceded by white space -->
                        <xsl:text> </xsl:text><xsl:value-of select="following-sibling::*[@xml:id=//ptr/@target/substring-after(., '#')]/child::metamark"/>
                    </xsl:if>
                </xsl:if>
                <xsl:text> | </xsl:text>
                
                <!-- add value of @place on metamark-->
                <xsl:if test="child::metamark[@function='transposition']/attribute::place"><xsl:value-of select="child::metamark[@function='transposition']/attribute::place"/></xsl:if>
                <xsl:text> | </xsl:text>
                
                <!-- non value for @agent expected -->
                 <xsl:text> | </xsl:text>
                
                <!-- add value of @source when encoded for metamark-->
                <xsl:if test="child::metamark[@function='transposition']/attribute::source"><xsl:value-of select="child::metamark[@function='transposition']/attribute::source"/></xsl:if>
                <xsl:text> | </xsl:text>
                
                <!-- empty fields  -->
                <xsl:text>  |  |  |  |  |  </xsl:text>
                
                <xsl:text> | &#x0a;</xsl:text> <!-- close beginning line-->
                
                <xsl:apply-templates/> <!-- process everything that is supposed to be in between the enclosing lines --> 
                
            </xsl:when>
            <xsl:otherwise>
            
            <xsl:apply-templates/> <!-- process everything that is supposed to be in between the enclosing lines --> 
                
                <!-- for last element in sequence print closing line -->
                <xsl:if test="self::*[@xml:id=//ptr/@target/substring-after(., '#')]/not(following-sibling::*[@xml:id=//ptr/@target/substring-after(., '#')])">
                
                <xsl:text> | ts | e | </xsl:text>  <!-- end tag -->
                
                <!-- empty fields-->
                <xsl:text> |  |  |  |  |  |  |  |  |  |  |  |  |  | </xsl:text>
                
                <xsl:text> | &#x0a;</xsl:text> <!-- close line-->
                </xsl:if>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
 
    
    
    <!-- templates for text altering markup inside of words or me:punct/pc-->
    <xsl:template match="ex|expan">
        <xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="abbr">
        <xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="unclear[ancestor::w]|unclear[ancestor::pc]|unclear[ancestor::me:punct]">
        <xsl:text>{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="c|hi">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="supplied[ancestor::w]|supplied[ancestor::pc]|supplied[ancestor::me:punct]|supplied[ancestor::num]|me:punct[ancestor::w][attribute::type='supplied']"> 
        <xsl:choose>
            <xsl:when test="attribute::reason='omitted'">
                <xsl:text>⟨</xsl:text><xsl:apply-templates/><xsl:text>⟩</xsl:text>
            </xsl:when>
            <xsl:when test="attribute::type='clarification'">
                <xsl:text>⟨</xsl:text><xsl:apply-templates/><xsl:text>⟩</xsl:text>
            </xsl:when>
            <xsl:when test="attribute::reason='illegible'">
                <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:when test="attribute::type='restoration'">
                <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
            </xsl:when> 
            <xsl:when test="attribute::subtype='omitted'"> <!-- for me:punct inside of w -->
                <xsl:text>⟨</xsl:text><xsl:apply-templates/><xsl:text>⟩</xsl:text>
            </xsl:when>
            <xsl:when test="attribute::subtype='illegible'"> <!-- for me:punct inside of w -->
                <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:otherwise><xsl:text>⟨</xsl:text><xsl:apply-templates/><xsl:text>⟩</xsl:text></xsl:otherwise> <!-- default -->
        </xsl:choose>
    </xsl:template>

    <xsl:template match="add[ancestor::w]|add[ancestor::pc]|add[ancestor::me:punct]"> <!-- for all different additions -->
        
        <xsl:choose>
            <xsl:when test="add[attribute::place/starts-with(., 'margin')]"> <!-- marginal -->
        <xsl:choose>
            <xsl:when test="add/attribute::place='margin-right'">
                <xsl:text>⸍</xsl:text><xsl:apply-templates/><xsl:text>⸌⸌</xsl:text>
            </xsl:when>
            <xsl:when test="add/attribute::place='margin-left'">
                <xsl:text>⸍⸍</xsl:text><xsl:apply-templates/><xsl:text>⸌</xsl:text>
            </xsl:when>
            <xsl:when test="add/attribute::place='margin-top'">
                <xsl:text>⸌⸌</xsl:text><xsl:apply-templates/><xsl:text>⸍⸍</xsl:text>
            </xsl:when>
            <xsl:when test="add/attribute::place='margin-bot'">
                <xsl:text>⸍⸍</xsl:text><xsl:apply-templates/><xsl:text>⸌⸌</xsl:text>
            </xsl:when>
            <xsl:otherwise><xsl:text>⸍</xsl:text><xsl:apply-templates/><xsl:text>⸌</xsl:text></xsl:otherwise> <!-- default margin -->
        </xsl:choose>
            </xsl:when>
            
            <xsl:when test="add[attribute::place='above']|add[ancestor::w][attribute::place='supralinear']"> <!-- above the line -->
                <xsl:text>⸌</xsl:text><xsl:apply-templates/><xsl:text>⸍</xsl:text>
            </xsl:when>
            
            <xsl:when test="add[attribute::place='below']|add[ancestor::w][attribute::place='infralinear']"> <!-- below the line -->
                <xsl:text>⸝</xsl:text><xsl:apply-templates/><xsl:text>⸜</xsl:text>
            </xsl:when>
            
            <xsl:when test="add[attribute::place='inline']|add[ancestor::w][attribute::place='interlinear']"> <!-- on the line -->
                <xsl:text>⸜</xsl:text><xsl:apply-templates/><xsl:text>⸝</xsl:text>
            </xsl:when>
            
            <xsl:otherwise> <xsl:text>⸌</xsl:text><xsl:apply-templates/><xsl:text>⸍</xsl:text></xsl:otherwise> <!-- else, i.e. default for add without place -->
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="sic[ancestor::w]"> 
        <xsl:text>!</xsl:text><xsl:apply-templates/><xsl:text>¡</xsl:text>
    </xsl:template>
    
    <xsl:template match="corr[ancestor::w]">
        <xsl:text>*</xsl:text><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="del[ancestor::w]|del[ancestor::pc]|del[ancestor::me:punct]">
        <xsl:text>⸠</xsl:text><xsl:apply-templates/><xsl:text>⸡</xsl:text>
    </xsl:template>
    
    <xsl:template match="surplus[ancestor::w]|me:suppressed[ancestor::w]|me:expunged[ancestor::w]|surplus[ancestor::pc]|me:suppressed[ancestor::pc]|me:expunged[ancestor::me:punct]|surplus[ancestor::me:punct]|me:suppressed[ancestor::me:punct]|me:expunged[ancestor::me:punct]"> 
        <xsl:text>⸡</xsl:text><xsl:apply-templates/><xsl:text>⸠</xsl:text>
    </xsl:template>
    
    <xsl:template match="gap[ancestor::w]">
        <xsl:text>€</xsl:text><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="gb[ancestor::w]">
        <xsl:text>£</xsl:text><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="space[ancestor::w]">
        <xsl:text>§</xsl:text><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="handShift[ancestor::w]">
        <xsl:text>@</xsl:text><xsl:apply-templates/>
    </xsl:template>
    

    <!-- templates for lb, cb and pb within a word --> 
    <xsl:template match="pb[ancestor::w]">
        <xsl:choose>
            <xsl:when test="@type='ed'"><xsl:text>⫽</xsl:text></xsl:when><!-- pb in edition -->
            <xsl:when test="@ed"><xsl:text></xsl:text>⫽</xsl:when><!-- pb in edition (variant XML coding) -->
            <xsl:otherwise><xsl:text>‖</xsl:text></xsl:otherwise> <!-- pb in manuscript -->
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="cb[ancestor::w]"> 
        <xsl:choose> <!-- only insert on markup on highest level, i.e. not if a pb is present  emmdiately in front in same <w> -->
            <xsl:when test="preceding-sibling::pb"></xsl:when>
            <xsl:otherwise>
        <xsl:choose>
            <xsl:when test="@type='ed'"><xsl:text>⸨</xsl:text></xsl:when><!-- cb in edition -->
            <xsl:when test="@ed"><xsl:text></xsl:text>⸨</xsl:when><!-- cb in edition (variant XML coding) -->
            <xsl:otherwise><xsl:text>⸩</xsl:text></xsl:otherwise> <!-- cb in manuscript -->
        </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="lb[ancestor::w]"> 
        <xsl:choose> <!-- only insert on markup on highest level, i.e. not if a cb and/or pb is present emmdiately in front in same <w> -->
            <xsl:when test="preceding-sibling::pb"></xsl:when>
            <xsl:when test="preceding-sibling::cb"></xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type='ed'"><xsl:text>⁄</xsl:text></xsl:when><!-- lb in edition -->
                    <xsl:when test="@ed"><xsl:text>⁄</xsl:text></xsl:when><!-- lb in edition (variant XML coding) -->
                    <xsl:otherwise> <!-- lb in manuscript -->
                        <xsl:if test="@rend">       <!-- if @rend present  -->
                            <xsl:choose>
                                <xsl:when test="@rend='hyphen'"><xsl:text>-¦</xsl:text></xsl:when> <!-- insert hyphen and broken pipe character -->
                                <xsl:otherwise><xsl:text>¦@rend</xsl:text><xsl:value-of select="@rend"/><xsl:text>¦</xsl:text> <!-- if not 'hyphen' (assumed: number value) add additional "@rend" + value of rend + broken pipe character -->
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:otherwise> 
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- do not print any text not contained by <w> or <pc>/<me:punct>, i.e. contents that might be contained by structural elements such as <head> -->
    <xsl:template match="text()[not(ancestor::w or ancestor::pc or ancestor::me:punct)]"></xsl:template>
        
    
</xsl:stylesheet>