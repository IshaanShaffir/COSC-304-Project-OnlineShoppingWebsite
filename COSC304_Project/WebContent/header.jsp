<header>
<H1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">Titan Tech Store</a></font></H1>      
<hr>
<H3>Current User: <% out.print(session.getAttribute("authenticatedUser"));%></H3>
<!-- TODO: Make it look nicer-->
	<a href="index.jsp">Home</a>
	<a href="listprod.jsp">Products</a>
	<a href="listorder.jsp">List Orders</a>
	<a href="showcart.jsp">Shopping Cart</a>
</header>
