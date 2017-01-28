<%@ page import="up.project.jsp.PostsBean" %>
<%@ page import="java.util.Vector" %><%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 11/29/2016
  Time: 9:30 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>liteBlog CP-Posts Page</title>
    <link rel="stylesheet" type="text/css" href="../assets/semantic/semantic.min.css">
</head>
<body>
<%
    if ((session.getAttribute("hasAccess") == null && session.getAttribute("isAdmin") == null &&
            session.getAttribute("userID") == null) || !session.getAttribute("hasAccess").equals("1")) {

        String url = "http://" + request.getServerName() + ":" + request.getServerPort() + "/cp/index.jsp";
        response.setStatus(response.SC_MOVED_TEMPORARILY);
        response.setHeader("Location", url);
        return;
    }

    Vector v1, v2;
    String conf = pageContext.getServletContext().getRealPath("/WEB-INF/config.txt");
    PostsBean postsBean = new PostsBean(conf);
    postsBean.setAdmin(Boolean.parseBoolean(session.getAttribute("isAdmin").toString()));
    postsBean.setUser_id(Integer.parseInt(session.getAttribute("userID").toString()));
    //set offset
    int pageNumber = 1;
    if (request.getParameter("page") != null) {
        pageNumber = Integer.parseInt(request.getParameter("page"));
    }
    int totalPosts = Integer.parseInt(postsBean.countPosts());
    int offset = 0;
    int pageNumbers = 0;
    if (totalPosts == 0) {
        totalPosts = 1;
        offset = 0;
    } else {
        pageNumbers = (int) Math.ceil(totalPosts / 10.0);
        offset = ((pageNumber - 1) * 10);
    }
    v1 = postsBean.getPostsWithPaginate(10, offset);

%>
<div class="ui container">
    <div class="ui menu">
        <div class="header item">liteBlog</div>
        <a class="item">Users Management</a>
        <a class="active item">Posts Management</a>
        <div class="right menu">
            <div class="ui inline dropdown item" tabindex="0">
                <div class="text">
                    <img class="ui avatar image" src="../assets/images/avatar.jpg">
                    <%= session.getAttribute("fullName") %>
                </div>
                <i class="dropdown icon"></i>
                <div class="menu">
                    <div class="item">
                        <a href="./service/user/signout.jsp">LogOut</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="ui breadcrumb">
        <a class="section">Home</a>
        <i class="right chevron icon divider"></i>
        <a class="active section">Posts Management</a>
    </div>
    <div class="clearing"></div>
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
    <div class="row">
        <div class="one column">
            <div class="ui left floated small primary labeled icon button" id="add-post"
                 style="margin-bottom: 10px; margin-top: 20px;">
                <i class="newspaper icon"></i> Add Post
            </div>
        </div>
    </div>
    <div class="clearing"></div>
    <table class="ui celled table">
        <thead>
        <tr>
            <th>Post Title</th>
            <th>Date</th>
            <th>Publisher</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < v1.size(); i++) {
            v2 = (Vector) v1.elementAt(i);
        %>
        <tr>
            <td>
                <%= v2.get(1)%>
            </td>
            <td><%= v2.get(3)%>
            </td>
            <td><%= v2.get(4)%>
            </td>
            <td width="140">
                <div class="ui icon buttons">
                    <button class="ui blue basic button edit-post" data-id="<%= v2.get(0)%>"
                            data-title="<%= v2.get(1)%>">
                        <i class="edit icon"></i>
                    </button>
                    <button class="ui red basic button delete-post" data-id="<%= v2.get(0)%>">
                        <i class="trash icon"></i>
                    </button>
                </div>
            </td>
        </tr>
        <% } %>
        <% if (v1.size() <= 0) {%>
        <tr>
            <td colspan="4"><h3 style="text-align: center;">There is no result!</h3></td>
        </tr>
        <% } %>
        </tbody>
        <tfoot>
        <tr>
            <th colspan="4">
                <div class="ui right floated pagination menu">
                    <a class="icon item">
                        <i class="left chevron icon"></i>
                    </a>
                    <% for (int i = 1; i <= pageNumbers; i++) {%>
                    <a class="item" href='posts.jsp?page=<%= i %>'><%= i %>
                    </a>
                    <% } %>
                    <a class="icon item">
                        <i class="right chevron icon"></i>
                    </a>
                </div>
            </th>

        </tr>
        </tfoot>
    </table>
    <div class="ui modal add-post">
        <i class="close icon"></i>
        <div class="header modal-header">
            Add New Post
        </div>
        <div class="content text">
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
            <div class="ui form">
                <div class="field">
                    <label>Title</label>
                    <input type="text" name="post_title" id="post_title">
                </div>
                <div class="field">
                    <label>Body</label>
                    <textarea name="post_body" id="post_body"></textarea>
                </div>
            </div>
        </div>
        <div class="actions">
            <input type="hidden" id="post_id" name="id">
            <input id="submit_form"  type="submit" data-action="add" class="ui green button" value="Add Post">
        </div>
    </div>
</div>

<div class="ui small basic test modal">
    <div class="ui icon header">
        <i class="trash icon"></i>
        Delete Post
    </div>
    <div class="content text">
        <p style="text-align: center;">Do you want to delete this post from LiteBlog website?</p>
    </div>
    <div class="actions">
        <div class="ui red basic cancel inverted button">
            <i class="remove icon"></i>
            No
        </div>
        <div class="ui green ok inverted button">
            <i class="checkmark icon"></i>
            Yes
        </div>
    </div>
</div>

</body>
<script src="../assets/jquery/jquery-3.1.1.min.js"></script>
<script src="../assets/semantic/semantic.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('.ui.dropdown').dropdown();
        $("#add-post").on('click', function () {
            $("#submit_form").data('action', 'add');
            var formTitle = "Add New Post";
            var buttonTitle = "Add Post";
            var url = "";
            $("#post_id").val("");
            $("#post_title").val("");
            $("#post_body").val("");
            //change add post modal ui data
            $('.ui.modal.add-post .header.modal-header').text(formTitle);
            $('.ui.modal.add-post button.ui.green').text(buttonTitle);
            //
            $('.ui.modal.add-post').modal({
                blurring: true
            }).modal('show');
        });
        $("button.edit-post").on('click', function () {
            $("#submit_form").data('action', 'update');
            var post_title = $(this).data("title");
            var formTitle = "Edit (" + post_title + ") Post";
            var buttonTitle = "Update Post";
            var url = "service/post/show.jsp";
            var id = $(this).data('id');
            showPost('get', url, {id: id})
            //change add post modal ui data
            $('.ui.modal.add-post .header.modal-header').text(formTitle);
            $('.ui.modal.add-post button.ui.green').text(buttonTitle);
            //

            $('.ui.modal.add-post').modal({
                blurring: true
            }).modal('show');
        });
        $("button.delete-post").on('click', function () {
            var id = $(this).data('id');
            var row = $(this).parent().parent().parent();
            $('.ui.basic.test.modal')
                    .modal({
                        closable: false,
                        onDeny: function () {
                        },
                        onApprove: function () {
                            $.ajax({
                                type: "get",
                                url: "service/post/delete.jsp",
                                data: {id: id},
                                dataType: 'json',
                            }).done(function (response) {
                                if (response.status_code == 200) {
                                    $(".ui.positive.message p").html(response.message);
                                    $(".ui.positive.message").show().delay(2000).hide(1000);
                                    row.remove();
                                }
                                if (response.status_code == 400) {
                                    $(".ui.negative.message p").html(response.message);
                                    $(".ui.negative.message").show().delay(2000).hide(1000);
                                }

                            }).fail(function (jqXHR) {
                                var json = $.parseJSON(jqXHR.responseText);
                                $(".alert-danger-msg").html("");
                                if (json.status_code == 500) {
                                    $(".ui.negative.message p").html("Some Errors has been accord!");
                                    $(".ui.negative.message").show().delay(2000).hide(1000);
                                }
                            });
                        }
                    })
                    .modal('show')
            ;
        });
        //////////////////
        $("#submit_form").on('click', function () {
            var action = $(this).data('action'); //add or update
            var id = $("#post_id").val();
            var title = $("#post_title").val();
            var body = $("#post_body").val();
            var img = "";
            if (action == "add") {
                formRequest('post', 'service/post/add.jsp', {title: title, body: body});
            } else {
                formRequest('post', 'service/post/update.jsp', {id: id, title: title, body: body});
            }
        });
        /////////////////
        function formRequest(method, action, data) {
            $("div.ui.form").addClass('loading');
            $.ajax({
                type: method,
                url: action,
                data: data,
                dataType: 'json',
            }).done(function (response) {
                if (response.status_code == 200 || response.status_code == 201) {
                    $(".ui.positive.message p").html(response.message);
                    $(".ui.positive.message").show().delay(2000).hide(1000);

                }
                if (response.status_code == 400) {
                    $(".ui.negative.message p").html(response.message);
                    $(".ui.negative.message").show().delay(2000).hide(1000);
                    $.each(response.error, function (key, val) {
                        $(".ui.negative.message").append('<p>' + val + '</p>')
                    });
                }
                $("div.ui.form").removeClass('loading');
            }).fail(function (jqXHR) {
                var json = $.parseJSON(jqXHR.responseText);
                $(".alert-danger-msg").html("");
                if (json.status_code == 500) {
                    $(".ui.negative.message p").html("Some Errors has been accord!");
                    $(".ui.negative.message").show().delay(2000).hide(1000);
                }
                $("div.ui.form").removeClass('loading');
            });
        }

        ///////////////////////
        function showPost(method, action, data) {
            $("div.ui.form").addClass('loading');
            $.ajax({
                type: method,
                url: action,
                data: data,
                dataType: 'json',
            }).done(function (response) {
                if (response.status_code == 200 || response.status_code == 201) {
                    $("#post_id").val(response.post.id);
                    $("#post_title").val(response.post.title);
                    $("#post_body").val(response.post.body);
                }
                if (response.status_code == 400) {
                    $(".ui.negative.message p").html(response.message);
                    $(".ui.negative.message").show().delay(2000).hide(1000);
                    $.each(response.error, function (key, val) {
                        $(".ui.negative.message").append('<p>' + val + '</p>')
                    });
                }
                $("div.ui.form").removeClass('loading');
            }).fail(function (jqXHR) {
                var json = $.parseJSON(jqXHR.responseText);
                $(".alert-danger-msg").html("");
                if (json.status_code == 500) {
                    $(".ui.negative.message p").html("Some Errors has been accord!");
                    $(".ui.negative.message").show().delay(2000).hide(1000);
                }
                $("div.ui.form").removeClass('loading');
            });
        }
    });
</script>
</html>
