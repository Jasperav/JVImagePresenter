## JVConstraintEdges 

Short introduction 
JVConstraintEdges makes it very easy to add views that are constrainted to other views. Along with extensions to UIView, adding views programmatically is fast and easy. 


## How to use 
This section is split up in two sections: 
1. The struct ConstraintEdges. 
2. General extensions. 

## ConstraintEdges 
ConstraintEdges is a struct with 4 properties: leading, top, trailing and bottom. It is very similar to UIRectInsets, however, all the properties of ConstraintEdges are optional. There are a lot of overloaded/convencience overloads available e.g.: 

    let edges = ConstraintEdges(all: 5) // Initializes all 4 properties with a value of 5 
    let view = UIView() 
    view.fill(toSuperview: mySuperview, edges: edges) * 
*-Omit the edges parameters to completetly fill the calling uiview to the superview. 
-Add toSafeEdges to the parameters to fill it to the safe areas. 

## General UIView extensions 
The following extensions are pretty commonly used: 
- Filling a view. 
    fill(toSuperview: UIView,  
        edges: ConstraintEdges? = nil,  
        addToSuperView: Bool = true,  
        toSafeMargins: Bool = false) 
This method is also seen in section ConstraintEdges. 

- Filling a view with a callback to the (added) constraints 
    fillWithResult(… activateConstraints: Bool = true) 
Fill with result does do the same thing as the normal fill function, but it returns the constraints it has added.  

- Set equal height/width to other UIView
    .equal(to: UIView, height: Bool, width: Bool) 
The function signature is pretty clear what it does. It equals the height and/or width from the calling view . 

TODO: Add more function descriptions. 
