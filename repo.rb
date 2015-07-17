//*****************************************************************//
//*****************************************************************//
//**                                                             **//
//**        (C)Copyright 2014, American Megatrends, Inc.         **//
//**                                                             **//
//**                     All Rights Reserved.                    **//
//**                                                             **//
//**       5555 Oakbrook Parkway, Suite 200, Norcross, GA 30093  **//
//**                                                             **//
//**                     Phone (770)-246-8600                    **//
//**                                                             **//
//*****************************************************************//
//*****************************************************************//
//*****************************************************************//

package com.ami.ui.gse.setupdata.xmlModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.jface.action.IAction;
import org.eclipse.ui.views.properties.IPropertyDescriptor;
import org.eclipse.ui.views.properties.IPropertySource;
import org.eclipse.ui.views.properties.PropertyDescriptor;
import org.eclipse.ui.views.properties.TextPropertyDescriptor;

import com.ami.ui.gse.setupdata.action.ChangeAttributeAction;
import com.ami.ui.gse.setupdata.action.ChangeTextAction;

/**
 * This class is super class of all the xmlelement. the class XMLProperty gives
 * this class the ability to fire property change.
 * 
 * @author fengl
 *
 */
public class XMLElement implements IAdaptable, Cloneable,
		Comparable<XMLElement>, IValue2 {
	static private Integer number = 1;
	private String ID;
	private String name = "";
	private String text = "";
	protected Map<String, AttributeValuePair> Attributes = new LinkedHashMap<String, AttributeValuePair>();
	protected List<XMLElement> Children = new ArrayList<XMLElement>();
	protected XMLElement parent = null;
	protected StringFactory stringFactory;

	public static final String ATTRIBUTE_ID = "id";

	/**
	 * constructor
	 */
	public XMLElement() {
		ID = createID();
	}

	/**
	 * constructor
	 * 
	 * @param parent
	 *            the parent xmlelement
	 * @param stringFactory
	 */
	public XMLElement(XMLElement parent, StringFactory stringFactory) {
		this.parent = parent;
		this.stringFactory = stringFactory;
		ID = createID();
	}

	/**
	 * Create the IDs for xmlelement. every element has an unequal ID,
	 * 
	 * @return the ID string
	 */
	static private String createID() {
		return (number++).toString();
	}

	/**
	 * Check this element is read only, or not
	 * 
	 * @return true, read only; false, not read only.
	 */
	public boolean isReadonly() {
		if (stringFactory == null) {
			return true;
		}
		return stringFactory.isReadOnly();
	}

	/**
	 * 
	 * @return the ID of this element
	 */
	public String getID() {
		return ID;
	}

	/**
	 * 
	 * @return the name of the element
	 */
	public String getName() {
		return name;
	}

	/**
	 * Set the name of the element
	 * 
	 * @param name
	 *            the name of the element
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * get parent
	 * 
	 * @return parent element
	 */
	public XMLElement getParent() {
		return parent;
	}

	/**
	 * set parent
	 * 
	 * @param parent
	 *            the parent
	 */
	public void setParent(XMLElement parent) {
		this.parent = parent;
	}

	/**
	 * get Strings factory
	 * 
	 * @return
	 */
	public StringFactory getStringFactory() {
		return stringFactory;
	}

	/**
	 * set Srings factory
	 * 
	 * @param stringFactory
	 */
	public void setStringFactory(StringFactory stringFactory) {
		this.stringFactory = stringFactory;
	}

	/**
	 * get text
	 * 
	 * @return the text
	 */
	public String getText() {
		return text;
	}

	/**
	 * set text
	 * 
	 * @param text
	 *            the text
	 */
	public void setText(String text) {
		this.text = text;
	}

	/**
	 * Get Attribute map
	 * 
	 * @return Attribute map
	 */
	public Map<String, AttributeValuePair> getAttributes() {
		return Attributes;
	}

	/**
	 * Get the list of AttributeValuePair
	 * 
	 * @return AttributeValuePair
	 */
	public List<AttributeValuePair> getAttributeValuePairs() {
		List<AttributeValuePair> list = new ArrayList<AttributeValuePair>();
		for (String key : Attributes.keySet()) {
			list.add(Attributes.get(key));
		}
		return list;
	}

	/**
	 * set Attribute list
	 * 
	 * @param attributes
	 */
	public void setAttributes(Map<String, AttributeValuePair> attributes) {
		Attributes = attributes;
	}

	/**
	 * get Child list
	 * 
	 * @return Child list
	 */
	public List<XMLElement> getChildren() {
		return Children;
	}

	public XMLElement getChildren(String id) {
		if (id == null || id.isEmpty()) {
			return null;
		}
		for (XMLElement xmlElement : Children) {
			if (id.equals(xmlElement.getAttribute(ATTRIBUTE_ID))) {
				return xmlElement;
			}
		}
		return null;
	}

	/**
	 * get the children set, within the ids set.
	 * 
	 * @param ids
	 *            the ids set
	 * @return the XMLElement set, the id within the ids set.
	 */
	public Set<XMLElement> getChildren(Set<String> ids) {

		Set<XMLElement> set = new HashSet<XMLElement>();
		if (ids == null) {
			return set;
		}
		for (XMLElement xmlElement : Children) {
			if (ids.contains(xmlElement.getAttribute(ATTRIBUTE_ID))) {
				set.add(xmlElement);
			}
		}
		return set;

	}

	/**
	 * get the correct type of children
	 * 
	 * @param adapter
	 *            class of the child
	 * @return the children set
	 */
	public Set<XMLElement> getChildren(Class<?> adapter) {

		Set<XMLElement> set = new HashSet<XMLElement>();
		for (XMLElement xmlElement : Children) {
			if (adapter.equals(xmlElement.getClass())) {
				set.add(xmlElement);
			}
		}
		return set;
	}

	/**
	 * set Child list
	 * 
	 * @param children
	 *            Child list
	 */
	public void setChildren(List<XMLElement> children) {
		Children = children;
	}

	/**
	 * Add Child
	 * 
	 * @param Child
	 * @return success or not
	 */
	public boolean addChild(XMLElement Child) {
		if (isChildType(Child)) {
			if (!Children.contains(Child)) {
				Children.add(Child);
				Child.setParent(this);
				return true;
			} else {
				return false;
			}
		}
		return false;
	}

	/**
	 * Add Child
	 * 
	 * @param Child
	 * @param index
	 * @return success or not
	 */
	public boolean addChild(XMLElement Child, int index) {
		if (isChildType(Child)) {
			if (Children.contains(Child)) {
				Children.remove(Child);
			}
			if (Children.size() < index || index < 0) {
				Children.add(Child);
			} else {
				Children.add(index, Child);
			}
			Child.setParent(this);
			return true;
		}
		return false;
	}

	/**
	 * Get the index of the Child in the Child list
	 * 
	 * @param Child
	 * @return the index of the Child in the Child list
	 */
	public int getChildIndex(XMLElement Child) {
		return Children.indexOf(Child);
	}

	/**
	 * Remove Child
	 * 
	 * @param Child
	 */
	public void removeChild(XMLElement Child) {
		Children.remove(Child);
	}

	/**
	 * Test whether the element is the child of this
	 * 
	 * @param element
	 * @return
	 */
	public boolean isChild(XMLElement element) {
		if (Children.contains(element)) {
			return true;
		}
		for (XMLElement child : Children) {
			if (child.isChild(element)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * add Child And Delete From Previous Parent
	 * 
	 * @param Child
	 * @return success or not
	 */
	public boolean addChildAndDeleteFromPreviousParent(XMLElement Child) {
		XMLElement oldparent = Child.getParent();
		if (oldparent != null && addChild(Child)) {
			oldparent.deleteChild(Child);
			return true;
		} else {
			return false;
		}
	}

	/**
	 * remove Child
	 * 
	 * @param Child
	 */
	public void deleteChild(XMLElement Child) {
		Children.remove(Child);
	}

	/**
	 * Set Attribute
	 * 
	 * @param key
	 *            Attribute
	 * @param value
	 *            value
	 */
	public void setAttribute(String key, String value) {
		if (key != null) {
			AttributeValuePair attributeValuePair = new AttributeValuePair(key,
					value);
			Attributes.put(key, attributeValuePair);
		}
	}

	/**
	 * get Attribute
	 * 
	 * @param key
	 *            Attribute
	 * @return value
	 */
	public String getAttribute(String key) {
		AttributeValuePair pair = Attributes.get(key);
		if (pair != null) {
			return pair.getValue();
		} else {
			return null;
		}
	}

	/**
	 * delete Attribute
	 * 
	 * @param key
	 *            Attribute
	 */
	public void deleteAttribute(String key) {
		Attributes.remove(key);
	}

	/**
	 * get Attribute Set
	 * 
	 * @return
	 */
	public Set<String> getAttributeSet() {
		return Attributes.keySet();
	}

	/**
	 * Get Adapter
	 */
	@Override
	public Object getAdapter(@SuppressWarnings("rawtypes") Class adapter) {
		if (adapter == IPropertySource.class) {
			return new XMLElementProperties(this);
		}
		return null;
	}

	/**
	 * get String By AttributeID from String Factory
	 * 
	 * @param attribute
	 * @return The ID value in String Factory
	 */
	public String smartGetAttribute(String attribute) {
		return getAttribute(attribute);
	}

	/**
	 * get String By TextID from String Factory
	 * 
	 * @return The ID value in String Factory
	 */
	public String smartGetText() {
		return getText();
	}

	/**
	 * set String By TextID from String Factory, Sub class need to overwrite
	 * this function, if needed.
	 */
	public void smartSetText(String text) {
		setText(text);
	}

	/**
	 * This one will be override in child class. in tree or table view gives the
	 * String to show in the view
	 * 
	 * @return
	 */
	public String getLabel() {
		return getName();
	}

	/**
	 * This one will be override in child class. when add a child check it can
	 * be added or not
	 * 
	 * @param element
	 * @return
	 */
	public boolean isChildType(Object element) {
		if (element instanceof XMLElement) {
			return true;
		}
		return false;
	}

	/**
	 * This one will be override in child class.
	 * 
	 * @return
	 */
	public Set<String> getUsedStringIDsOnlyOfThis() {
		return new HashSet<String>();
	}

	/**
	 * This one returns the used string ids except me;
	 * 
	 * @return
	 */
	public Set<String> getUsedStringIDs() {
		Set<String> set = new HashSet<String>();
		for (XMLElement child : Children) {
			set.addAll(child.getUsedStringIDs());
		}
		set.addAll(getUsedStringIDsOnlyOfThis());
		return set;
	}

	/**
	 * This one returns the used string ids except me;
	 * 
	 * @return
	 */
	public Set<String> getUsedStringIDs(XMLElement me) {
		Set<String> set = new HashSet<String>();
		if (this == me) {
			return set;
		}
		for (XMLElement child : Children) {
			set.addAll(child.getUsedStringIDs(me));
		}
		set.addAll(getUsedStringIDsOnlyOfThis());
		return set;
	}

	/**
	 * get all the used string Ids, include all the children and this object
	 * 
	 * @param list
	 * @return
	 */
	public Set<String> getUsedStringIDs(List<XMLElement> list) {
		Set<String> set = new HashSet<String>();
		for (XMLElement element : list) {
			if (this == element) {
				return set;
			}
		}
		for (XMLElement child : Children) {
			set.addAll(child.getUsedStringIDs(list));
		}
		set.addAll(getUsedStringIDsOnlyOfThis());
		return set;
	}

	/**
	 * check the attribute name is a string Id or not. this function have to be
	 * overwrite by the sub class.
	 * 
	 * @param attribute
	 *            attribute name
	 * @return true Id, false not id.
	 */
	public boolean attributeIsStringId(String attribute) {
		return false;
	}

	/**
	 * check the text is a string Id or not. this function have to be overwrite
	 * by the sub class.
	 * 
	 * @return true Id, false not id.
	 */
	public boolean textIsStringId() {
		return false;
	}

	/**
	 * getAll the target pages id, related to all the children and this object.
	 * 
	 * @return
	 */
	public Set<String> getTargets() {
		Set<String> set = new HashSet<String>();
		for (XMLElement child : Children) {
			set.addAll(child.getTargets());
		}
		set.remove(null);
		set.remove("");
		return set;
	}

	/**
	 * For Class XMLElement, this function is the same as setAttribute(String,
	 * String). Because this class has on knowledge about the attribute, all the
	 * attributes is strings for this class. ALL the sub classes should override
	 * this function, determent to invoke the StringFactory.SetStringById Or
	 * this.setAttribute
	 * 
	 * @param key
	 *            Attribute
	 * @param value
	 *            value
	 */
	public void smartSetAttribute(String key, String value) {
		setAttribute(key, value);
	}

	/**
	 * clone
	 */
	@Override
	public Object clone() {
		XMLElement object;
		try {
			object = (XMLElement) super.clone();

			object.ID = createID();
			object.Attributes = new HashMap<String, AttributeValuePair>();
			Set<String> keySet = Attributes.keySet();
			for (String string : keySet) {
				object.Attributes.put(string, (AttributeValuePair) Attributes
						.get(string).clone());
			}
			object.Children = new ArrayList<XMLElement>();
			for (XMLElement xmlElement : Children) {
				object.addChild((XMLElement) xmlElement.clone());
			}
			return object;
		} catch (CloneNotSupportedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * if all the text, name, Attributes, and Children are the same return true
	 */
	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof XMLElement)) {
			return false;
		}
		if (obj == this) {
			return true;
		}
		if (!((XMLElement) obj).name.equals(name)) {
			return false;
		}
		if (!((XMLElement) obj).text.equals(text)) {
			return false;
		}
		if (!((XMLElement) obj).Attributes.equals(Attributes)) {
			return false;
		}
		if (!((XMLElement) obj).Children.equals(Children)) {
			return false;
		}
		return true;
	}

	@Override
	public int hashCode() {
		int code = 0;
		if (name != null) {
			code += name.hashCode();
		}
		if (text != null) {
			code += text.hashCode();
		}
		if (Attributes != null) {
			code += Attributes.hashCode();
		}
		if (Children != null) {
			code += Children.hashCode();
		}
		return code;
	}

	/**
	 * This function have to be override by the sub class. if need sort.
	 */
	@Override
	public int compareTo(XMLElement o) {
		return 0;
	}

	@Override
	public String toString() {
		return getName() + hashCode() + "ID:" + getID();
	}

	@Override
	public void setValue(String value) {
		// TODO Auto-generated method stub

	}

	@Override
	public String getValue() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getSpecificName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<IValue2> getIValue2s() {
		// TODO Auto-generated method stub
		return null;
	}

}

/**
 * The purpose of this class is to show the properties in the eclipse property
 * view.
 * 
 * @author fengl
 *
 */
class XMLElementProperties implements IPropertySource {

	XMLElement element;
	protected static final String PROPERTY_TEXT = "Text";
	protected static final String PROPERTY_Attributes = "Attributes";
	protected static final String PROPERTY_Flags = "Flags";
	protected boolean readOnly = false; // if the readonly flag set, the class
										// will return

	/**
	 * constructor
	 * 
	 * @param element
	 */
	public XMLElementProperties(XMLElement element) {
		this.element = element;
		readOnly = element.isReadonly();
	}

	/**
	 * Returns a value for this property source that can be edited in a property
	 * sheet.
	 */
	@Override
	public Object getEditableValue() {
		return element.getName();
	}

	/**
	 * get PropertyDescriptors
	 */
	@Override
	public IPropertyDescriptor[] getPropertyDescriptors() {
		PropertyDescriptor textPropertyDescriptor;
		List<IPropertyDescriptor> list = new ArrayList<IPropertyDescriptor>();
		if (element.getText() != null && !element.getText().isEmpty()) {
			if (readOnly) {
				textPropertyDescriptor = new PropertyDescriptor(PROPERTY_TEXT,
						PROPERTY_TEXT);
			} else {
				textPropertyDescriptor = new TextPropertyDescriptor(
						PROPERTY_TEXT, PROPERTY_TEXT);
			}
			textPropertyDescriptor.setCategory(PROPERTY_TEXT);
			list.add(textPropertyDescriptor);
		}

		Collection<String> collection = element.getAttributes().keySet();
		for (Iterator<String> iterator = collection.iterator(); iterator
				.hasNext();) {
			String string = iterator.next();
			if (element.getAttributes().get(string) instanceof AttributeValuePair_Flag) {
				AttributeValuePair_Flag attributeValuePair_Flag = (AttributeValuePair_Flag) element.getAttributes().get(string);
				FlagInfo FlagInfos[] = attributeValuePair_Flag.getFlagInfos();
				for (FlagInfo flagInfo : FlagInfos) {
					textPropertyDescriptor = new TextPropertyDescriptor(flagInfo.flagName,
							flagInfo.flagName);
					textPropertyDescriptor.setCategory(PROPERTY_Flags);
					list.add(textPropertyDescriptor);
				}
				
				continue;
			}
			if (readOnly) {
				textPropertyDescriptor = new PropertyDescriptor(string, string);
			} else {
				textPropertyDescriptor = new TextPropertyDescriptor(string,
						string);
			}
			textPropertyDescriptor.setCategory(PROPERTY_Attributes);
			list.add(textPropertyDescriptor);
		}
		IPropertyDescriptor[] T = new IPropertyDescriptor[list.size()];
		return list.toArray(T);
	}

	/**
	 * Returns the value of the property with the given id if it has one.
	 * Returns null if the property's value is null value or if this source does
	 * not have the specified property.
	 */
	@Override
	public Object getPropertyValue(Object id) {
		if (id != null) {
			if (id.equals(PROPERTY_TEXT)) {
				return element.smartGetText();
			}
			
					return element.smartGetAttribute((String)id);
			
		}
		return null;
	}

	/**
	 * Returns whether the value of the property with the given id has changed
	 * from its default value. Returns false if this source does not have the
	 * specified property.
	 */
	@Override
	public boolean isPropertySet(Object id) {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * Resets the property with the given id to its default value if possible.
	 */
	@Override
	public void resetPropertyValue(Object id) {
		// TODO Auto-generated method stub

	}

	/**
	 * Sets the property with the given id if possible. Does nothing if the
	 * property's value cannot be changed or if this source does not have the
	 * specified property.
	 */
	@Override
	public void setPropertyValue(Object id, Object value) {
		if (id != null) {
			if (id.equals(PROPERTY_TEXT)) {
				IAction action = new ChangeTextAction(element
						.getStringFactory().getUndoContext(), (String) value,
						element);
				action.run();
			}
			Collection<String> collection = element.getAttributes().keySet();
			for (Iterator<?> iterator = collection.iterator(); iterator
					.hasNext();) {
				String string = (String) iterator.next();
				if (id.equals(string)) {
					IAction action = new ChangeAttributeAction(element
							.getStringFactory().getUndoContext(), string,
							(String) value, element);
					action.run();
				}
			}
		}
	}

}
# testing
