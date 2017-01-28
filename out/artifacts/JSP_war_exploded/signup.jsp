<%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 11/29/2016
  Time: 9:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sign-Up - MyBlog</title>
    <link rel="stylesheet" type="text/css" href="./assets/semantic/semantic.min.css">
    <style type="text/css">
        body {
            background-color: #DADADA;
        }
        body > .grid {
            height: 100%;
        }
        .image {
            margin-top: -100px;
        }
        .column {
            max-width: 450px;
        }
    </style>
</head>
<body>
<div class="ui middle aligned center aligned grid">
    <div class="column">
        <h2 class="ui teal image header">
            <div class="content">
                Create new account
            </div>
        </h2>
        <form class="ui large form" method="post" action="cp/service/user/signup.jsp">
            <div class="ui stacked segment">
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        <input type="text" name="first_name" placeholder="First Name">
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        <input type="text" name="last_name" placeholder="Last Name">
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="envelope icon"></i>
                        <input type="text" name="email" placeholder="E-mail address">
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="lock icon"></i>
                        <input type="password" name="password" placeholder="Password">
                    </div>
                </div>
                <input type="submit" class="ui fluid large teal submit button" value="SignUp"/>
            </div>

            <div class="row" style="margin-top: 30px;">
                <div class="one column">
                    <div class="ui positive message" style="display: none;">
                        <i class="close icon"></i>
                        <div class="header">
                            This Action has been performed successfully
                        </div>
                        <p>Your post has been updated</p>
                    </div>
                    <div class="ui negative message" style="display: none;">
                        <i class="close icon"></i>
                        <div class="header">
                            We're sorry we can't apply that action
                        </div>
                        <p>Some error has been accorded!
                        </p>
                    </div>
                </div>
            </div>
            <div class="clearing"></div>

        </form>

        <div class="ui message">
            Do you have account? <a href="cp/index.jsp">Sign In</a>
        </div>
    </div>
</div>
</body>
<script src="./assets/jquery/jquery-3.1.1.min.js"></script>
<script src="./assets/semantic/semantic.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("form").submit(function (event) {
            var form = $(this);
            form.addClass('loading');
            var method = $(this).attr('method');
            var action = $(this).attr('action');
            var data = $(this).serialize();
            $.ajax({
                type: method,
                url: action,
                data: data,
                dataType: 'json',
            }).done(function (response) {
                if (response.status_code == 200 ||response.status_code == 201) {
                    $(".ui.positive.message p").html(response.message);
                    $(".ui.positive.message").show().delay(5000).hide(1000);

                }
                if (response.status_code == 400) {
                    $(".ui.negative.message p").html(response.message);
                    $(".ui.negative.message").show().delay(5000).hide(1000);
                    $.each(response.error, function (key, val) {
                        $(".ui.negative.message").append('<p>'+val+'</p>')
                    });
                }
                form.removeClass('loading');
            }).fail(function (jqXHR) {
                var json = $.parseJSON(jqXHR.responseText);
                $(".alert-danger-msg").html("");
                if (json.status_code == 500) {
                    $(".ui.negative.message p").html("Some Errors has been accord!");
                    $(".ui.negative.message").show().delay(5000).hide(1000);
                }
                form.removeClass('loading');
            });
            event.preventDefault();
        });

    });
</script>
</html>
