# Create IAM and Bucket policies
data "aws_iam_policy_document" "s3_pol" {
  statement {
    actions = [
      "s3:GetObject"
      ]
    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.oai.iam_arn}"]
    }
    resources = ["${aws_s3_bucket.cdn.arn}/*"]
  }
}
/*
data "aws_iam_policy_document" "s3_pol_rwd" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
      ]
    principals 
    {"AWS": ["arn:aws:iam::111122223333:root","arn:aws:iam::444455556666:root"]},
    
    resources = ["${aws_s3_bucket.cdn.arn}/*"]
  }
}
*/
resource "aws_s3_bucket_policy" "atch_s3_pol_attach" {
  bucket = aws_s3_bucket.cdn.id
  policy = data.aws_iam_policy_document.s3_pol.json
}