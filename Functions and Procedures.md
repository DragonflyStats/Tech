Excel VBA: Functions and Procedures


Calling a Sub Procedure
Procedures and Access Levels

````
Sub ProcedureName()

End Sub
````
The name of a procedure should follow the same rules we learned to name the variables. In addition:

If the procedure performs an action that can be represented with a verb, you can use that verb to name it. Here are examples: show, display
To make the name of a procedure stand, you should start it in uppercase. Examples are Show, Play, Dispose, Close

You should use explicit names that identify the purpose of the procedure. If a procedure would be used as a result of another procedure or a control's event, reflect it on the name of the sub procedure. Examples would be: afterupdate, longbefore.

If the name of a procedure is a combination of words, you should start each word in uppercase. An example is AfterUpdate
The section between the Sub and the End Sub lines is referred to as the body of the procedure. Here is an example:

Sub CreateCustomer()

End Sub
In the body of the procedure, you carry the assignment of the procedure. It is also said that you define the procedure or you implement the procedure.

One of the actions you can in the body of a procedure consists of declaring a variable. There is no restriction on the type of variable you can declare in a procedure. Here is an example:

Sub CreateCustomer()
	Dim strFullName As String
End Sub
In the same way, you can declare as many variables as you need inside of a procedure. The actions you perform inside of a procedure depend on what you are trying to accomplish. For example, a procedure can simply be used to create a string. The above procedure can be changed as follows:

Sub CreateCustomer()
	Dim strFullName As String

	strFullName = "Paul Bertrand Yamaguchi"
End Sub

Calling a Sub Procedure
Once you have a procedure, whether you created it or it is part of the Visual Basic language, you can use it. Using a procedure is also referred to as calling it.

Before calling a procedure, you should first locate the section of code in which you want to use it. To call a simple procedure, type its name. Here is an example:

Sub CreateCustomer()
	Dim strFullName As String

	strFullName = "Paul Bertrand Yamaguchi"
End Sub

Sub Exercise()
	CreateCustomer
End Sub
Besides using the name of a procedure to call it, you can also precede it with the Call keyword. Here is an example:

Sub CreateCustomer()
	Dim strFullName As String

	strFullName = "Paul Bertrand Yamaguchi"
End Sub

Sub Exercise()
	Call CreateCustomer
End Sub
When calling a procedure, without or without the Call keyword, you can optionally type an opening and a closing parentheses on the right side of its name. Here is an example:

Sub CreateCustomer()
	Dim strFullName As String

	strFullName = "Paul Bertrand Yamaguchi"
End Sub

Sub Exercise()
	CreateCustomer()
End Sub
Procedures and Access Levels
Like a variable access, the access to a procedure can be controlled by an access level. A procedure can be made private or public. To specify the access level of a procedure, precede it with the Private or the Public keyword. Here is an example:

Private Sub CreateCustomer()
	Dim strFullName As String

	strFullName = "Paul Bertrand Yamaguchi"
End Sub
The rules that were applied to global variables are the same:

Private: If a procedure is made private, it can be called by other procedures of the same module. Procedures of outside modules cannot access such a procedure.Also, when a procedure is private, its name does not appear in the Macros dialog box.

Public: A procedure created as public can be called by procedures of the same module and by procedures of other modules. Also, if a procedure was created as public, when you access the Macros dialog box, its name appears and you can run it from there
