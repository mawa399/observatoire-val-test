<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer><Name>ventes_type_local</Name>
    <UserStyle><Title>Ventes par type de bien</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Maison</Title>
          <ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>type_local</ogc:PropertyName><ogc:Literal>Maison</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter>
          <PointSymbolizer><Graphic>
            <Mark><WellKnownName>circle</WellKnownName>
              <Fill><CssParameter name="fill">#1b9e77</CssParameter></Fill>
              <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">0.8</CssParameter></Stroke>
            </Mark><Size>8</Size>
          </Graphic></PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Appartement</Title>
          <ogc:Filter><ogc:PropertyIsEqualTo><ogc:PropertyName>type_local</ogc:PropertyName><ogc:Literal>Appartement</ogc:Literal></ogc:PropertyIsEqualTo></ogc:Filter>
          <PointSymbolizer><Graphic>
            <Mark><WellKnownName>circle</WellKnownName>
              <Fill><CssParameter name="fill">#7570b3</CssParameter></Fill>
              <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">0.8</CssParameter></Stroke>
            </Mark><Size>8</Size>
          </Graphic></PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
