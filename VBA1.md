
VBA Operators
 
Introduction
An operation is an action performed on one or more values either to modify one value or to produce a new value by combining existing values. Therefore, an operation is performed using at least one symbol and one value. The symbol used in an operation is called an operator. A variable or a value involved in an operation is called an operand.

A unary operator is an operator that performs its operation on only one operand.
An operator is referred to as binary if it operates on two operands.


Dimensioning a Variable
The Assignment Operator
The Line Continuation Operator
The Parentheses
The Comma
The Double Quotes
The Colon Operator
String Concatenation
Carriage Return-Line Feed

Dimensioning a Variable
When interacting with Microsoft Excel, you will be asked to provide a value. Sometimes, you will be presented with a value to view or change. Besides the values you use in a spreadsheet, in the previous lesson, we learned that we could also declare variables in code and assign values to them.

We could use the Dim operator to declare a variable. Here is an example:
	Option Explicit 
	Sub Exercise() 
		Dim Value 
	End Sub

After declaring a variable like this, we saw that we could then use it as we saw fit.
####The Assignment Operator
We mentioned that you could declare a variable but not specify the type of value that would be stored in the memory area reserved for it. When you have declared a variable, the computer reserves space in the memory and gives an initial value to the variable. If the variable is number based, the computer gives its memory an intial value of 0. If the variable is string based, thecomputer fills its memory with an empty space, also referred to as an empty string.

Initializing a variable consists of giving it a value as soon as the variable has been declared. To initialize a variable, you use the assignment operator which is "=". You type the name of the variable, followed by =, and followed by the desired value. The value depends on the type of variable. If the variable is integral based, give it an appropriate natural number. Here is an example:

	Sub Exercise() 
	Dim Integral As Integer 
		Integral = 9578 
	End Sub

If the variable is made to hold a decimal number, initialize it with a number that can fit in its type of variable. Here is an example:

		Sub Exercise() 
	Dim Distance As Double 
		Distance = 257.84 
	End Sub

If the variable is for a string, you can initialize it with an empty string or put the value inside of double-quotes.
####The Line Continuation Operator
If you plan to write a long piece of code, to make it easier to read, you may need to divide it in various lines. To do this, you can use the line continuation operator represented by a white space followed by an underscore.

To create a line continuation, put an empty space, then type the underscore, and continue your code in the next line. Here is an example:
Sub _ Exercise() End Sub

The Parentheses
Parentheses are used in various circumstances. The parentheses in an operation help to create sections in an operation. This regularly occurs when more than one operators are used in an operation. Consider the following operation:
8 + 3 * 5

The result of this operation depends on whether you want to add 8 to 3 then multiply the result by 5 or you want to multiply 3 by 5 and then add the result to 8. Parentheses allow you to specify which operation should be performed first in a multi-operator operation. In our example, if you want to add 8 to 3 first and use the result to multiply it by 5, you would write (8 + 3) * 5. This would produce 55. On the other hand, if you want to multiply 3 by 5 first then add the result to 8, you would write 8 + (3 * 5). This would produce 23.

As you can see, results are different when parentheses are used on an operation that involves various operators. This concept is based on a theory called operator precedence. This theory manages which operation would execute before which one; but parentheses allow you to completely control the sequence of these operations.
####The Comma 
The comma is used to separate variables used in a group. For example, a comma can be used to delimit the names of variables that are declared on the same line. Here is an example:
Sub Exercise() Dim FirstName As String, LastName As String, FullName As String End Sub
The Double Quotes
A double-quote is used to delimit a group of characters and symbols. To specify this delimitation, the double-quote is always used in combination with another double-quote, as in "". What ever is inside the double-quotes is the thing that need to be delimited. The value inside the double-quotes is called a string. Here is an example:
Sub Exercise() Dim FirstName As String, LastName As String, FullName As String FirstName = "Valère" ActiveCell.FormulaR1C1 = FirstName End Sub
####The Colon Operator 
Most of the time, to make various statements easier to read, you write each on its own line. Here are examples:
Sub Exercise() Dim FirstName As String, LastName As String FirstName = "Valère" LastName = "Edou" End Sub

The Visual Basic language allows you to write as many statements as necessary on the same line. When doing this, the statements must be separated by a colon. Here is an example:
Sub Exercise() Dim FirstName As String, LastName As String FirstName = "Valère" : LastName = "Edou" ActiveCell.FormulaR1C1 = FirstName End Sub
String Concatenation
The & operator is used to append two strings or expressions. This is considered as concatenating them. For example, it could allow you to concatenate a first name and a last name, producing a full name. The general syntax of the concatenation operator is:
Value1 & Value2
In the same way, you can use as many & operators as you want between any two strings or expressions. After concatenating the expressions or values, you can assign the result to another variable or expression using the assignment operator. Here are examples:
Sub Exercise() Dim FirstName As String, LastName As String, FullName As String FirstName = "Valère" LastName = "Edou" FullName = FirstName & " " & LastName End Sub
Carriage Return-Line Feed
If you are displaying a string but judge it too long, you can segment it in appropriate sections as you see fit. To do this, you can use vbCrLf. Here is an example:
Sub Exercise() Dim FirstName As String, LastName As String, FullName As String Dim Accouncement As String FirstName = "Valère" LastName = "Edou" FullName = FirstName & " " & LastName Accouncement = "Student Registration - Student Full Name: " & _ vbCrLf & FullName ActiveCell.FormulaR1C1 = Accouncement End Sub

####Arithmetic Operators
