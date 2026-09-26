<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer><Name>zones_projet</Name>
    <UserStyle><Title>Zones de projet</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Zone de projet</Title>
          <PolygonSymbolizer>
            <Fill><GraphicFill><Graphic><Mark><WellKnownName>shape://slash</WellKnownName>
              <Stroke><CssParameter name="stroke">#6a3d9a</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
            </Mark><Size>8</Size></Graphic></GraphicFill></Fill>
            <Stroke><CssParameter name="stroke">#6a3d9a</CssParameter><CssParameter name="stroke-width">2</CssParameter></Stroke>
          </PolygonSymbolizer>
          <TextSymbolizer>
            <Label><ogc:PropertyName>nom</ogc:PropertyName></Label>
            <Font><CssParameter name="font-family">Arial</CssParameter><CssParameter name="font-size">11</CssParameter><CssParameter name="font-weight">bold</CssParameter></Font>
            <Halo><Radius>2</Radius><Fill><CssParameter name="fill">#ffffff</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#6a3d9a</CssParameter></Fill>
          </TextSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
