<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/bag.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">주문내역 조회</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-3">
		<ul class="nav nav-pills" role="tablist">
			<li class="nav-item">
				<a class="nav-link active" data-toggle="pill" href="#home">입금/결제</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" data-toggle="pill" href="#menu1">배송중</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" data-toggle="pill" href="#menu2">배송완료</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" data-toggle="pill" href="#menu3">교환</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" data-toggle="pill" href="#menu4">환불</a>
			</li>
		</ul>
		
		<!-- 날짜 선택란 -->
		<form action="orderList" method="get" class="form-inline">
			<div class="form-group" >
				<input type="date" id="startDate" name="startDate" >&nbsp;
				<input type="date" id="endDate" name="endDate" >&nbsp;
				<button type="button" class="btn btn-primary btn-sm" onclick="">조회하기</button>
			</div>
		</form>
	</div>
	
	<br>

	<div class="form-group">
		<table>
			<thead>
				<tr>
					<th style="width: 450px">상품정보</th>
					<th style="width: 200px">주문일자</th>
					<th style="width: 200px">주문번호</th>
					<th style="width: 200px">주문금액(수량)</th>
					<th style="width: 200px">주문상태</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach var="order" items="${orders}" varStatus="loop">

					<c:if test="${loop.first}">
						<tr>
							<td colspan="5" style="padding-top: 10px;"></td>
						</tr>
					</c:if>

					<tr>
						<td style="padding-left: 20px; text-align: left;">
							<div style="display: flex; align-items: center;">
								<a href="/project4/product?cmd=detail&id=${order.productId }">
									<img src="/project4/images/productImg/${order.img}" alt="Product Image" style="width: 70px; height: auto; margin-right: 10px;">
								</a>
								<div>
									<strong>${order.brand}</strong><br> ${order.content}
								</div>
							</div>
						</td>
						<td>
							<fmt:formatDate pattern="yyyy-MM-dd" value="${order.createDate}"></fmt:formatDate>
						</td>
						<td>
							<span><a href="/project4/buy?cmd=detail&orderNum=${order.orderNum }">${order.orderNum}</a></span>
						</td>
						<td>
							<fmt:formatNumber type="number" pattern="#,##0" value="${order.totalPrice}" />원 <br> 
							<span style="color: grey">${order.totalCount}개</span>
						</td>
						<td>
							<span>${order.state}</span><br>
							<button type="button" class="btn btn-outline-info btn-sm">교환</button>
							<button type="button" class="btn btn-outline-danger btn-sm">환불</button>
						</td>
					</tr>
					<!-- 각 주문 항목 아래에 선 추가 -->
					<c:if test="${loop.last || !loop.last}">
						<tr>
							<td colspan="5">
								<hr style="border-color: lightgrey;">
							</td>
						</tr>
					</c:if>
				</c:forEach>
				<c:if test="${empty orders}">
					<tr>
						<td colspan="5">주문 내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

</div>

<style>

thead th {
	border-top: 1px solid;
	border-bottom: 1px solid;
	padding-top: 10px;
	padding-bottom: 10px;
}

.nav-pills .nav-link {
    padding: 5px 10px; 
}
.nav-pills .nav-item {
    margin-right: 5px;
}
.nav-pills .nav-link:not(.active) {
	color: grey;
    background-color: #f2f2f2; 
}

/* a태그 스타일*/
/* a 태그 기본 색상을 검정색으로 설정 */
a {
    color: black;
    text-decoration: none; /* 밑줄 없애기 */
}

/* a 태그에 마우스를 올렸을 때 색상을 회색으로 설정 (선택 사항) */
a:hover {
    color: #CB444A;
    text-decoration: underline; /* 밑줄 추가 (선택 사항) */
}


</style>

<%@ include file = "../layout/footer.jsp" %>