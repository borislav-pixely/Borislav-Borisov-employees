# Borislav-Borisov-employees

<b>iOS Task</b>: Find pairs of employees who have worked together in a CSV file</br>
<b>Minimum iOS version required</b>: 14.0</br>
<b>Using</b>: Swift & UIKit</br></br>
<b>Screenshots</b>:</br>

<img src="https://github.com/borislav-pixely/Borislav-Borisov-employees/assets/18205439/d9fdefb4-844d-45bd-894c-c140f3d2db9a" width=200/>
<img src="https://github.com/borislav-pixely/Borislav-Borisov-employees/assets/18205439/567f2a88-6a50-4a5a-b0c3-b62854166664" width=200/>
<img src="https://github.com/borislav-pixely/Borislav-Borisov-employees/assets/18205439/ad34131d-cd73-4d1f-ac6a-018f3b526358" width=200/>
<img src="https://github.com/borislav-pixely/Borislav-Borisov-employees/assets/18205439/8acf95a5-edeb-44ee-8ce8-0e357207e59a" width=200/>

</br></br>
<b>Requirements</b>:<br/>
1) Input data: A CSV file with data in the following format: EmpID, ProjectID, DateFrom, DateTo
2) Sample data: 143, 12, 2013-11-01, 2014-01-05
3) DateTo can be NULL, equivalent to today
4) The input data must be loaded to the program from a CSV file
5) Create an UI:
The user picks up a file from the file system and, after selecting it, all common
projects of the pair are displayed in datagrid with the following columns:
Employee ID #1, Employee ID #2, Project ID, Days worked
6) Bonus points: More than one date format to be supported, extra points will be given if all date formats
are supported
