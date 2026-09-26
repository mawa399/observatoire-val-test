<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer><Name>prix_m2_classes</Name>
    <UserStyle><Title>Prix médian au m²</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Moins de 2 300 €/m²</Title>
          <ogc:Filter><ogc:PropertyIsLessThan><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>2300</ogc:Literal></ogc:PropertyIsLessThan></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#fef0d9</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>2 300 à 2 800 €/m²</Title>
          <ogc:Filter><ogc:And><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>2300</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyIsLessThan><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>2800</ogc:Literal></ogc:PropertyIsLessThan></ogc:And></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#fdcc8a</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>2 800 à 3 500 €/m²</Title>
          <ogc:Filter><ogc:And><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>2800</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyIsLessThan><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>3500</ogc:Literal></ogc:PropertyIsLessThan></ogc:And></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#fc8d59</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>3 500 €/m² et plus</Title>
          <ogc:Filter><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>prix_m2_median</ogc:PropertyName><ogc:Literal>3500</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#d7301f</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>Nom de la commune</Title>
          <MaxScaleDenominator>150000</MaxScaleDenominator>
          <TextSymbolizer>
            <Label><ogc:PropertyName>nom</ogc:PropertyName></Label>
            <Font><CssParameter name="font-family">Arial</CssParameter><CssParameter name="font-size">12</CssParameter></Font>
            <LabelPlacement><PointPlacement><AnchorPoint><AnchorPointX>0.5</AnchorPointX><AnchorPointY>0.5</AnchorPointY></AnchorPoint></PointPlacement></LabelPlacement>
            <Halo><Radius>2</Radius><Fill><CssParameter name="fill">#ffffff</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#222222</CssParameter></Fill>
          </TextSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
