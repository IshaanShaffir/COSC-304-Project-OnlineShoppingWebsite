<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
String newQty = request.getParameter("newQty");
String prodId = request.getParameter("prodId");
String deleteItem = request.getParameter("deleteItem");

if (productList == null){	
	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else{
	if(newQty!=null && prodId!=null){
		boolean isNum = true;
		for(int i=0; i<newQty.length(); i++){
			if(!Character.isDigit(newQty.charAt(i))){
				isNum=false;
				break;
			}
		}
		if(isNum && productList.containsKey(prodId)){
			ArrayList<Object> itemList = productList.get(prodId);
			itemList.set(3,new Integer(Integer.parseInt(newQty)));
		}
	}

	if(deleteItem!=null){
		if(productList.containsKey(deleteItem)){
			productList.remove(deleteItem);
		}
	}

	NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><td></td><td></td></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		/*Bonus Marks:
		*Added ability to change quantity of item in cart
		*Added ability to remove item from cart later on in document
		*/
		out.println("<tr><form method=\"get\" action=\"showcart.jsp\"><input type=\"hidden\" name=\"prodId\" value=\""+product.get(0)+"\">");
		out.println("<td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td align=\"center\"><input type=\"text\" name=\"newQty\" size=\"3\" value=\""+product.get(3)+"\"></td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}	

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");

		/*Bonus Mark
		*Added ability to remove item from Cart
		*/
		out.print("<td><a href=\"showcart.jsp?deleteItem="+product.get(0)+"\">Remove from cart</a></td>");
		out.print("<td><input type=\"submit\" value=\"Change Quantity\"></td>");
		out.println("</form>");
		out.print("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
session.setAttribute("productList", productList);
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html> 

