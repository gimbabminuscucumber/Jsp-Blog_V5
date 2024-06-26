package com.cos.blog.domain.product;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.product.dto.DetailRespDto;
import com.cos.blog.domain.product.dto.SaveReqDto;

public class ProductDao {

	// 상품 등록
	public int save(SaveReqDto dto) throws IOException {			
		// 이미지 파일 경로 저장
		String imagePath = uploadImage(dto.getImgInputStream(), dto.getImgFileName());
		String explainPath = uploadImage(dto.getExplainInputStream(), dto.getExplainFileName());
		if(imagePath == null) {
			return -1;	// 이미지 업로드 실패 시 처리
		}
		
		String sql = "INSERT INTO product(userId, price, categoryId, weight, brand, img, content, explanation, createDate) VALUES(?,?,?,?,?,?,?,?, now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getPrice());
			pstmt.setInt(3, dto.getCategoryId());
			pstmt.setString(4, dto.getWeight());
			pstmt.setString(5, dto.getBrand());
//			pstmt.setString(6, dto.getImg());	
			pstmt.setString(6, dto.getImgFileName());// 이미지 경로 저장
			pstmt.setString(7, dto.getContent());		// 간단 설명
			pstmt.setString(8, dto.getExplainFileName());		// 제품 상세설명
			
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	// 이미지 파일 업로드 및 경로 변환 메소드
	public String uploadImage(InputStream fileInputStream, String fileName) throws IOException {
	    String uploadPath = "/Users/gimdong-eun/Desktop/STS/Workspace2_JSP/project4/src/main/webapp/images/productImg/";
	    Path path = Paths.get(uploadPath + fileName);
	    Files.createDirectories(path.getParent()); // 디렉토리가 존재하지 않으면 생성

	    if (Files.exists(path)) {   	// 이미 파일이 존재하는지 확인
	        Files.delete(path);      	// 파일이 이미 존재하면 삭제
	    }

	    Files.copy(fileInputStream, path); // 파일 복사
	    return path.toString();
	}
	
	// 페이징 처리 (기본 페이지에서의 상품개수)
	public int count() {
		String sql = "SELECT count(*) FROM product";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally { 
			DB.close(conn, pstmt, rs);
		}
 		return -1; 
	}

	// 페이징 처리 (검색 페이지)
	public int keywordCount(String keyword) {
		String sql = "SELECT count(*) FROM product WHERE brand LIKE ? OR content LIKE ? ";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
			rs = pstmt.executeQuery();				
		
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally { 
			DB.close(conn, pstmt, rs);
		}
 		return -1; 
	}
	
	// 페이징 처리 (카테고리 페이지)
	public int categoryCount(int categoryId) {
		String sql = "SELECT count(*) FROM product WHERE categoryId LIKE ?";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;	
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, categoryId);
			rs = pstmt.executeQuery();				
			
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally { 
			DB.close(conn, pstmt, rs);
		}
		return -1; 
	}

	
	// 상품 리스트
	public List<DetailRespDto> findAll(int page) {
		String sql = "SELECT * FROM product ORDER BY id DESC LIMIT ?,16";		// 16 : 페이지에 출력할 객체 최대개수 
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DetailRespDto>products = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, page*16);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("id"))
						.userId(rs.getInt("userId"))
						.price(rs.getInt("price"))
						.categoryId(rs.getInt("categoryId"))
						.count(rs.getInt("count"))
						.weight(rs.getString("weight"))
						.brand(rs.getString("brand"))
						.img(rs.getString("img"))
						.content(rs.getString("content"))
						.createDate(rs.getTimestamp("createDate"))
						.view(rs.getInt("view"))
						.build();
				products.add(dto);
			}
			return products;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 상품 삭제
	public int deleteById(int id) {
		String sql = "DELETE FROM product WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	// 상품 찾기
	public DetailRespDto findById(int id) {
		String sql = "SELECT * FROM product WHERE id =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				DetailRespDto dto = new DetailRespDto();
				dto.setId(rs.getInt("id"));
				dto.setUserId(rs.getInt("userId"));
				dto.setPrice(rs.getInt("price"));
				dto.setCategoryId(rs.getInt("categoryId"));
				dto.setCount(rs.getInt("count"));
				dto.setBrand(rs.getString("brand"));
				dto.setWeight(rs.getString("weight"));
				dto.setContent(rs.getString("content"));
				dto.setImg(rs.getString("img"));
				dto.setCreateDate(rs.getTimestamp("createDate"));
				dto.setView(rs.getInt("view"));
				dto.setExplanation(rs.getString("explanation"));
				return dto;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 구매 횟수
	public int updateProductCount(int productId, int quantity) {
	    String sql = "UPDATE product SET count = count + ? WHERE id = ?";
	    Connection conn = DB.getConnection();
	    PreparedStatement pstmt = null;

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, quantity);
	        pstmt.setInt(2, productId);
	        int result = pstmt.executeUpdate();
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt);
	    }
	    return -1;
	}

	// 상품 검색
	public List<DetailRespDto> findByKeyword(String keyword, int page) {
		String sql = "SELECT * FROM product WHERE brand LIKE ? OR content LIKE ? ORDER BY id DESC LIMIT ?, 16";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DetailRespDto> products = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
			pstmt.setInt(3, page*16);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("id"))
						.userId(rs.getInt("userId"))
						.price(rs.getInt("price"))
						.categoryId(rs.getInt("categoryId"))
						.weight(rs.getString("weight"))
						.brand(rs.getString("brand"))
						.content(rs.getString("content"))
						.createDate(rs.getTimestamp("createDate"))
						.count(rs.getInt("count"))
						.img(rs.getString("img"))
						.view(rs.getInt("view"))
						.explanation(rs.getString("explanation"))
						.build();
				products.add(dto);
			}
			return products;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 카테고리별 상품 목록
	public List<DetailRespDto> findByCategory(int categoryId, int page) {
		String sql = "SELECT * FROM product WHERE categoryId = ? ORDER BY id DESC LIMIT ?, 16";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DetailRespDto> products = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, categoryId);
			pstmt.setInt(2, page*16);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("id"))
						.userId(rs.getInt("userId"))
						.price(rs.getInt("price"))
						.categoryId(rs.getInt("categoryId"))
						.weight(rs.getString("weight"))
						.brand(rs.getString("brand"))
						.content(rs.getString("content"))
						.createDate(rs.getTimestamp("createDate"))
						.count(rs.getInt("count"))
						.img(rs.getString("img"))
						.view(rs.getInt("view"))
						.explanation(rs.getString("explanation"))
						.build();
				products.add(dto);
			}
			return products;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 상품 조회수
	public int viewUp(int id) {
		String sql = "UPDATE product SET view = view +1 WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			int result = pstmt.executeUpdate();
			return result; 
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	// 많이 본 상품
	public List<DetailRespDto> findByView() {
		String sql = "SELECT * FROM product ORDER BY view DESC LIMIT 4";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DetailRespDto> suggests = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("id"))
						.userId(rs.getInt("userId"))
						.price(rs.getInt("price"))
						.categoryId(rs.getInt("categoryId"))
						.count(rs.getInt("count"))
						.weight(rs.getString("weight"))
						.brand(rs.getString("brand"))
						.img(rs.getString("img"))
						.content(rs.getString("content"))
						.createDate(rs.getTimestamp("createDate"))
						.view(rs.getInt("view"))
						.explanation(rs.getString("explanation"))
						.build();
				suggests.add(dto);
			}
			return suggests;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 추천 상품
	public List<DetailRespDto> findByBrand(String brand) {
		String sql = "SELECT * FROM product WHERE brand = ? ORDER BY view DESC LIMIT 4";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DetailRespDto> suggests = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, brand);
			rs = pstmt.executeQuery();
			System.out.println("ProductDao/findByBrand/pstmt : " + pstmt);
			System.out.println("ProductDao/findByBrand/rs : " + rs);
			System.out.println("ProductDao/findByBrand/conn : " + conn);
			
			while(rs.next()) {
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("id"))
						.userId(rs.getInt("userId"))
						.price(rs.getInt("price"))
						.categoryId(rs.getInt("categoryId"))
						.count(rs.getInt("count"))
						.weight(rs.getString("weight"))
						.brand(rs.getString("brand"))
						.img(rs.getString("img"))
						.content(rs.getString("content"))
						.createDate(rs.getTimestamp("createDate"))
						.view(rs.getInt("view"))
						.explanation(rs.getString("explanation"))
						.build();
				suggests.add(dto);
				System.out.println("ProductDao/findByBrand/dto : " + dto);
			}
			System.out.println("ProductDao/findByBrand/suggests : " + suggests);
			return suggests;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt,rs);
		}
		return null;
	}

	// 상품 수정
	public int update(SaveReqDto dto) throws IOException {

		System.out.println("ProductDao/update/진입");
		// 이미지 파일 경로 저장
		String imagePath = uploadImage(dto.getImgInputStream(), dto.getImgFileName());
		String explainPath = uploadImage(dto.getExplainInputStream(), dto.getExplainFileName());
		if(imagePath == null) {
			return -1;	// 이미지 업로드 실패 시 처리
		}
		String sql = "UPDATE product SET userId=?, price=?, categoryId=?, brand=?, content=?, weight=?, img=?, explanation=? WHERE id=?";
	    Connection conn = DB.getConnection();
	    PreparedStatement pstmt = null;
	    
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, dto.getUserId());
	        pstmt.setInt(2, dto.getPrice());
	        pstmt.setInt(3, dto.getCategoryId());
	        pstmt.setString(4, dto.getBrand());
	        pstmt.setString(5, dto.getContent());
	        pstmt.setString(6, dto.getWeight());
	        pstmt.setString(7, dto.getImgFileName()); 			// 이미지 파일 경로
	        pstmt.setString(8, dto.getExplainFileName());		// 설명 파일 경로
	        pstmt.setInt(9, dto.getId()); 									// 수정할 상품의 ID
	        
	        System.out.println("ProductDao/update 111");
	        
	        int result = pstmt.executeUpdate();
	        System.out.println("ProductDao/update/result : " + result);
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	System.out.println("ProductDao/update 222");
	        DB.close(conn, pstmt);
	    }
	    return -1;
	}


	
}
