<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print out total order amount by day
String sql = "select year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{	
	out.println("<h3>Administrator Sales Report by Day</h3>");
	
	getConnection();
	Statement stmt = con.createStatement(); 
	stmt.execute("USE orders");

	ResultSet rst = con.createStatement().executeQuery(sql);		
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");	

	while (rst.next())
	{
		out.println("<tr><td>"+rst.getString(1)+"-"+rst.getString(2)+"-"+rst.getString(3)+"</td><td>"+currFormat.format(rst.getDouble(4))+"</td></tr>");
	}
	out.println("</table>");		
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>

<H1>Customer List</H1>
<Table border="1">
<tr><th>Customer Id</th><th>First Name</th><th>Last Name</th><th>email</th><th>Phone #</th><th>address</th><th>city</th><th>state</th><th>postal Code</th><th>Country</th><th>user Id</th></tr>
<%
String sql2 = "SELECT * FROM customer";
try{
	getConnection();

	Statement stmt = con.createStatement();

	stmt.execute("USE orders");
	ResultSet rst = stmt.executeQuery(sql2);

	while(rst.next()){
		out.print("<tr>");
		out.print("<td>"+rst.getInt(1)+"</td>");
		for(int i=2; i<12; i++){
			out.print("<td>"+rst.getString(i)+"</td>");
		}
		out.println("</tr>");
		
	}


	closeConnection();
} catch(Exception e){

}



%>

</Table>

<H1>Add new product</H1>
<form method="get" action="admin.jsp">
<Table>
<tr><th><label>Product Name:</label></th><td><input type="text" name="productName"></td></tr>
<tr><th><label>Product Price:</label></th><td><input type="text" name="productPrice"></td></tr>
<tr><th><label>Product Description:</label></th><td><input type="text" name="productDesc"></td></tr>
<tr><th><label>Category:</label></th><td>
<select name="category">
  <option>Beverages</option>
  <option>Condiments</option>
  <option>Confections</option>
  <option>Dairy Products</option>
  <option>Grains/Cereals</option>
  <option>Meat/Poultry</option>
  <option>Produce</option>
  <option>Seafood</option> 
</select>
</td></tr>
<tr><th><label>Image Url:</label></th><td><input type = "text" name="imageUrl"></td></tr>
<!--<tr><th><label>Image:</label></th><td><input type="file" name="img" accept=".jpg" enctype="multipart/form-data"></td></tr>-->
</Table><br><br>
<input type="submit" value="Create Product"/>
</form>
<%




String name = request.getParameter("productName");
String price = request.getParameter("productPrice");
String desc = request.getParameter("productDesc");
String category = request.getParameter("category");
//String image = request.getParameter("img");
String imageUrl = request.getParameter("imageUrl");



if(name!=null && price!=null && category!=null && !name.equals("") && !price.equals("")){
	double priceDouble;
	try{
		priceDouble = Double.parseDouble(price);
		try{
			getConnection();
		con.createStatement().execute("USE orders");
		PreparedStatement categoryPstmt = con.prepareStatement("SELECT * FROM category WHERE categoryName = ?");
		categoryPstmt.setString(1, category);
		ResultSet categoryRst = categoryPstmt.executeQuery();
		int key;

		if(categoryRst.next()){
			int categoryInt = categoryRst.getInt(1);

			String sql3 = "INSERT INTO product(productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";

			PreparedStatement pstmt = con.prepareStatement(sql3, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, name);
			pstmt.setDouble(2, priceDouble);
			pstmt.setString(3, desc);
			pstmt.setInt(4, categoryInt);
			pstmt.executeUpdate();
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			key = keys.getInt(1);

			/*if(image!=null){
			Part filePart = request.getPart("img");
    		InputStream fileContent = filePart.getInputStream();

			String sql4 = "UPDATE product SET productImage = ? WHERE productId = ?";
			PreparedStatement pstmt4 = con.prepareStatement(sql4);	
			pstmt4.setBinaryStream(1, fileContent);
			pstmt4.setInt(2,key);
			pstmt4.executeUpdate();
			}*/
			if(imageUrl!=null){
				String sql4 = "UPDATE product SET productImageUrl = ? WHERE productId = ?";
				PreparedStatement pstmt4 = con.prepareStatement(sql4);
				pstmt4.setString(1,imageUrl);
				pstmt4.setInt(2, key);
				pstmt4.executeUpdate();
			}
		}
		}catch(Exception e){
			out.println(e.toString());
		}	

	} catch(Exception e){
		
	}
	
}


sql = "SELECT P.productId, productName, productPrice, categoryName, C.categoryId FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN orderproduct OP ON OP.productId = P.productId GROUP BY P.productId,P.productName,P.productPrice,C.categoryName,C.categoryId ORDER BY SUM(OP.quantity)";


// Colors for different item categories
HashMap<String,String> colors = new HashMap<String,String>();		// This may be done dynamically as well, a little tricky...
colors.put("Beverages", "#0000FF");
colors.put("Condiments", "#FF0000");
colors.put("Confections", "#000000");
colors.put("Dairy Products", "#6600CC");
colors.put("Grains/Cereals", "#55A5B3");
colors.put("Meat/Poultry", "#FF9900");
colors.put("Produce", "#00CC00");
colors.put("Seafood", "#FF66CC");

try 
{
	getConnection();
	Statement stmt = con.createStatement(); 			
	stmt.execute("USE orders");
	
	PreparedStatement pstmt = con.prepareStatement(sql);

	
	ResultSet rst = pstmt.executeQuery();
	
	out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th>Product Name</th>");
	out.println("<th>Category</th><th>Price</th><td/><td/></tr>");
	while (rst.next()) 
	{
		int id = rst.getInt(1);					

		String itemCategory = rst.getString(4);
		
		String color = (String) colors.get(itemCategory);
		if (color == null)
			color = "#FFFFFF";

		out.print("<tr><form method=\"get\" action=\"updateProd.jsp\"><input type=\"hidden\" value=\""+id+"\" name=\"id\"><td><input name=\"name\" type=\"text\" value=\"" + rst.getString(2) + "\"</td>"+ "<td><select name=\"category\">");
				
				getConnection();
	Statement stmt2 = con.createStatement(); 			
	stmt2.execute("USE orders");
	Statement stmt6 = con.createStatement();
 	ResultSet rst6 = stmt6.executeQuery("SELECT categoryName, categoryId FROM category");
    while (rst6.next()){
		int categoryInt = rst6.getInt(2);
		String categoryStr = rst6.getString(1);
		String outStr;
		if(itemCategory.equals(categoryStr)){
			outStr = "<option value=\""+categoryInt+"\" selected=\"selected\" >" + categoryStr + "</option>";
		}else{
			outStr="<option value=\""+categoryInt+"\">"+categoryStr + "</option>";
		}
		
		out.println(outStr);
	
	}
			
	closeConnection();

				
				out.println("</select></td>"
				+ "<td><input type=\"text\" name=\"price\" value=\"" + rst.getDouble(3)
				+ "\"</td><td><input type=\"submit\" value=\"Update\"></td><td><a href=\"deleteProd.jsp?id="+id+"\">Delete</a></td></form></tr>");
	}
	out.println("</table></font>");
	closeConnection();
} catch (SQLException ex) {
	out.println(ex);
}





%>

<H1>Warehouses</H1>


</body>
</html>

