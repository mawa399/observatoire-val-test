<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer><Name>taux_logement_social</Name>
    <UserStyle><Title>Taux de logements sociaux</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Moins de 10 %</Title>
          <ogc:Filter><ogc:PropertyIsLessThan><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>10</ogc:Literal></ogc:PropertyIsLessThan></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#eff3ff</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>10 à 20 %</Title>
          <ogc:Filter><ogc:And><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>10</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyIsLessThan><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>20</ogc:Literal></ogc:PropertyIsLessThan></ogc:And></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#9ecae1</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>20 à 25 %</Title>
          <ogc:Filter><ogc:And><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>20</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyIsLessThan><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>25</ogc:Literal></ogc:PropertyIsLessThan></ogc:And></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#4292c6</CssParameter></Fill>
            <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Title>25 % et plus (objectif SRU)</Title>
          <ogc:Filter><ogc:PropertyIsGreaterThanOrEqualTo><ogc:PropertyName>taux_ls</ogc:PropertyName><ogc:Literal>25</ogc:Literal></ogc:PropertyIsGreaterThanOrEqualTo></ogc:Filter>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#08519c</CssParameter></Fill>
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
