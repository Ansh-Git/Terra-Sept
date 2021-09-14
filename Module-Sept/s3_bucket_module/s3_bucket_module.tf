# S3 Bucket Creation
resource "aws_s3_bucket" "SepBucket" {
  bucket = "bucket-sep-test-bucket"
  acl    = "private"

  tags = {
    Name        = "Module-bucket-sep"
    Environment = "Test"
  }
}

# Upload Object to S3 Bucket

resource "aws_s3_bucket_object" "test-module-object" {
  bucket = "${aws_s3_bucket.SepBucket.id}"
  key    = "TestFileNew.txt"
  source = "TestFileNew.txt"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("TestFileNew.txt")
}