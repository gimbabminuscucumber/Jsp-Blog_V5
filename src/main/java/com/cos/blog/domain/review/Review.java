package com.cos.blog.domain.review;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Review {
	private int id;						// pk
	private int userId;				// fk
	private int buyId;				// fk
	private int productId;		// fk
	private int score;				// 별점 
	private String text;			// 내용
	private int status;				// 리뷰 작성 여부
	private Timestamp createDate;
}
