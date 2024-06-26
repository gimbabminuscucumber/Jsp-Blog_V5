<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>hoons' grocery store</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
 <!-- marterial css 
 https://materializecss.com/icons.html-->
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>
<style>
	
	a {
	    color: black;
	    text-decoration: none; 
	}
	
	a:hover {
	    color: #CB444A;
	    text-decoration: underline; 
	}

</style>

	<!-- 최상단 바 -->
	<nav class="navbar navbar-expand-md bg-dark navbar-dark">
	
		<!-- 로고 -->
		<a class="navbar-brand" href="<%=request.getContextPath()%>/product?cmd=list&page=0">
			<img src="images/hoons2.png" alt="Logo" style="width:90px;">
		</a>
		<!-- 사이트 좌우간격 줄이면 나오는 세 줄 버튼 -->
		<button class="navbar-toggler" type="button" data-toggle="collapse"data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<c:choose>
			<c:when test="${sessionScope.principal != null }">
				<div class="collapse navbar-collapse" id="collapsibleNavbar">
					 <!-- 로그인 상태 -->	
					<ul class="navbar-nav">
						<c:if test="${sessionScope.principal.userRole == 'ADMIN'}">
                            <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/product?cmd=saveForm">상품 등록</a></li>
                        </c:if>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/product?cmd=list&page=0">상품 목록</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/buy?cmd=basketList&id=${principal.id }" >장바구니</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/buy?cmd=list&page=0&userId=${principal.id }" >주문 내역</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/board?cmd=list&page=0">커뮤니티</a></li>
						<%-- <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=test">테스트 페이지</a></li> --%>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a></li>
					</ul>
	
					<!-- 드롭다운 -->
					<ul class="navbar-nav ml-auto" style="cursor:pointer">
					    <div class="dropdown">
					        <li class="d-flex" data-toggle="dropdown">
					            <img src="images/user.png" alt="Logo" style="width:40px; heigh:1px">
					            <a class="nav-link" href="#">${sessionScope.principal.nickName}</a>
					        </li>
					        <div class="dropdown-menu ">
					            <a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=updateForm&id=${sessionScope.principal.id}">회원정보</a>
					            <a class="dropdown-item" href="<%=request.getContextPath()%>/buy?cmd=basketList&id=${principal.id }" >장바구니</a>
					            <a class="dropdown-item" href="<%=request.getContextPath()%>/buy?cmd=list&id=${principal.id }" >주문 내역</a>
					            <a class="dropdown-item" href="<%=request.getContextPath()%>/board?cmd=saveForm">게시글 작성</a>
					            <a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a>
					            <c:if test="${sessionScope.principal.userRole == 'ADMIN'}">
						            <div class="dropdown-divider"></div>
						            <a class="dropdown-item" href="<%=request.getContextPath()%>/buy?cmd=manageOrder&page=0">주문 관리</a>
						            <a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=manageUser&page=0">회원 관리</a>
					            </c:if>
					        </div>
					    </div>
					</ul>
						
				</div>
			</c:when>
			
			<c:otherwise><!-- 비로그인 상태 -->
				<div class="collapse navbar-collapse" id="collapsibleNavbar">
					<ul class="navbar-nav">
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=joinForm">회원가입</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=loginForm">로그인</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/product?cmd=list&page=0">상품 목록</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/board?cmd=list&page=0">커뮤니티</a></li>
						<%-- <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=test">테스트 페이지</a></li> --%>
					</ul>
				</div>
			</c:otherwise>
			
		</c:choose>
	</nav>
	<br>