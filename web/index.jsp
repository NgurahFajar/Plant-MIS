<%-- 
    Document   : index
    Created on : Aug 20, 2024, 1:27:11 PM
    Author     : ktanjana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Welcome to QDEP</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(to right, #A1E3F9, #C2F2D0);
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }

            h1 {
                color: #2c3e50;
                margin-bottom: 20px;
            }

            a {
                text-decoration: none;
                padding: 12px 24px;
                background-color: #6fdf89;
                color: white;
                border-radius: 8px;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }

            a:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>
        <h1>Hello QDEP 👋</h1>
        <a href="login.jsp">Plant MIS</a>
    </body>
</html>
