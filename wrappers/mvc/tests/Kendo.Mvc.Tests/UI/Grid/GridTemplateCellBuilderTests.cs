namespace Kendo.Mvc.UI.Html.Tests
{
    using System.Collections.Generic;
    using Kendo.Mvc.Extensions;
    using Kendo.Mvc.UI;
    using Kendo.Mvc.UI.Tests;
    using Xunit;
    
    public class GridTemplateCellBuilderTests
    {
        private GridTemplateCellBuilder<Customer> builder;

        [Fact]
        public void Should_return_td()
        {
            builder = new GridTemplateCellBuilder<Customer>(new HtmlTemplate<Customer>());
            builder.Callback = delegate { };
            
            var td = builder.CreateCell(null);

            td.TagName.ShouldEqual("td");
        }
        
        [Fact]
        public void Should_apply_template()
        {
            var template = new HtmlTemplate<Customer>();

            template.Html = "foo";
            
            builder = new GridTemplateCellBuilder<Customer>(template);
            builder.Callback = delegate { };
         
            var td = builder.CreateCell(null);

            td.InnerHtml.ShouldEqual("foo");
        }

        [Fact]
        public void Should_apply_attributes()
        {
            builder = new GridTemplateCellBuilder<Customer>(new HtmlTemplate<Customer>());
            builder.Callback = delegate { };
            builder.HtmlAttributes.Merge(new { width = 100 });

            var td = builder.CreateCell(null);

            td.Attributes().ContainsKey("width").ShouldBeTrue();
        }
    }
}