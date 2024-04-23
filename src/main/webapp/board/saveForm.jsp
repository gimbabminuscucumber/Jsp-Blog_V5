<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<!-- 
해당 페이지로 직접 URL(자원에 직접 접근 '파일.확장자') 접근을 하게 되면 Controller 외에 추가적으로 View 파일 내부에서 세션을 또 체크해야 함
- 단점 : 모듈 분리가 안됨, 모든 파일에서 세션 체크를 해야 함
- 해결 방법 : 필터에 .jsp로 접근하는 모든 접근을 막으면 됨
-->

<div class="container">
	<form action="/project4/board?cmd=save" method="POST">
		<input type="hidden" name="userId" value="${sessionScope.principal.id }">
		<div class="form-group">
			<label for="title">Title:</label> 
			<input type="text" class="form-control" placeholder="제목을 입력하세요" id="title" name="title">
		</div>

		<div class="form-group">
			<label for="content">Content:</label>
			<textarea id="summernote" class="form-control" rows="5" id="content" name="content"></textarea>
		</div>

		<button type="submit" class="btn btn-primary">글쓰기 등록</button>
	</form>
</div>

<script>
	$('#summernote').summernote({ // summernote id를 찾아서 summersnote() 를 실행해라
		placeholder : '내용을 작성하세요',
		tabsize : 2,
		height : 200
	});
</script>
</body>
</html>
