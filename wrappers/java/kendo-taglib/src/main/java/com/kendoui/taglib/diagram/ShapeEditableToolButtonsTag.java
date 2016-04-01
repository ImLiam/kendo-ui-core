
package com.kendoui.taglib.diagram;


import com.kendoui.taglib.BaseTag;




import java.util.ArrayList;
import java.util.Map;
import java.util.List;

import javax.servlet.jsp.JspException;

@SuppressWarnings("serial")
public class ShapeEditableToolButtonsTag extends BaseTag /* interfaces */ /* interfaces */ {
    
    @Override
    public int doEndTag() throws JspException {
//>> doEndTag
//<< doEndTag

        return super.doEndTag();
    }

    @Override
    public void initialize() {
//>> initialize

        buttons = new ArrayList<Map<String, Object>>();

//<< initialize

        super.initialize();
    }

    @Override
    public void destroy() {
//>> destroy
//<< destroy

        super.destroy();
    }

//>> Attributes

    private List<Map<String, Object>> buttons;

    public List<Map<String, Object>> buttons() {
        return buttons;
    }

    public static String tagName() {
        return "diagram-shape-editable-tool-buttons";
    }

    public void addButton(ShapeEditableToolButtonTag value) {
        buttons.add(value.properties());
    }

//<< Attributes

}