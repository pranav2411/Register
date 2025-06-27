<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NWR Internal Login</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f9;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        /* Preloader */
        #preloader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: white;
            z-index: 10000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'DotGothic16', monospace;
            font-size: 22px;
            animation: fadeOut 0.5s ease-in-out 2s forwards;
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                visibility: hidden;
            }
        }

        /* 🚂 Train Banner */
        .train-banner {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 50px;
            background-color: #333;
            color: white;
            overflow: hidden;
            display: flex;
            align-items: center;
            padding-left: 10px;
            font-size: 18px;
            z-index: 9999;
            font-family: 'DotGothic16', monospace;
            letter-spacing: 2px;
        }

        .train {
            position: absolute;
            white-space: nowrap;
            animation: moveTrain 15s linear infinite;
        }

        @keyframes moveTrain {
            0% { left: 100%; }
            100% { left: -100%; }
        }

        /* Main Container */
        .container {
            flex: 1;
            display: flex;
            width: 100%;
            padding-top: 60px;
        }

        .left-panel {
            width: 50%;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .left-panel img {
            max-width: 90%;
            height: auto;
        }

        .right-panel {
            width: 50%;
            background: #f4f6f9;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            font-family: 'DotGothic16', monospace;
        }

        .login-box {
            background: #ffffff;
            padding: 40px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }

        .login-box h2 {
            margin-bottom: 10px;
        }

        .login-box p {
            color: #777;
            margin-bottom: 30px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        input[type="submit"] {
            background-color: #6a5acd;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: red;
        }

        .error {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }

        .extras {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 10px 0;
        }

        .extras a {
            text-decoration: none;
            font-size: 14px;
            color: #555;
        }

        .register-link {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }

        .register-link a {
            color: #337ab7;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=DotGothic16&display=swap" rel="stylesheet">
    <script>
        window.onload = function() {
            setTimeout(function() {
                document.getElementById("preloader").style.display = "none";
            }, 2000);
        };
    </script>
</head>
<body>

<!-- 🚄 Preloader -->
<div id="preloader">
    Loading North Western Railways...
</div>

<!-- 🚂 Train Banner -->
<div class="train-banner">
    <div class="train">
        North Western Railways – Serving with Safety & Speed
    </div>
</div>

<!-- 💻 Main Layout -->
<div class="container">

    <!-- 🟨 Logo Side -->
    <div class="left-panel">
        <img src="https://logowik.com/content/uploads/images/indian-railways3115.jpg" alt="Indian Railways Logo">
    </div>

    <!-- 🟦 Login Form Side -->
    <div class="right-panel">
        <div class="login-box">
            <h2>Log In</h2>
            <p>Welcome to North Western Railway Internal System</p>
            <form action="login" method="post">
                <input type="text" name="username" placeholder="Username"
       value="<%= request.getCookies() != null ?
                java.util.Arrays.stream(request.getCookies())
                .filter(c -> "rememberUser".equals(c.getName()))
                .findFirst()
                .map(c -> c.getValue())
                .orElse("") : "" %>" required>

                <input type="password" name="password" placeholder="Password" required>
                <div class="extras">
                    <label><input type="checkbox" name="remember"> Remember me</label>

                    <a href="forgot-password.jsp">Forgot Password?</a>
                </div>
                <input type="submit" value="Log In">
            </form>

            <div class="error">
                <%= request.getParameter("error") != null ? "Invalid username or password!" : "" %>
            </div>

            
        </div>
    </div>

</div>

</body>
</html>
