/*
resource "aws_eks_cluster" "personal" {
  name     = "Personal"
  role_arn = aws_iam_role.personal.arn

  vpc_config {
    subnet_ids = [aws_subnet.personal_private.id, aws_subnet.personal_private_1.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.personal
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.personal.name
  addon_name   = "vpc-cni"
}

resource "aws_iam_role" "personal" {
  name = "eks"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "personal" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.personal.name
}

data "tls_certificate" "personal" {
  url = aws_eks_cluster.personal.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "personal" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.personal.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.personal.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "vpc_cni" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.personal.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.personal.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "vpc_cni" {
  assume_role_policy = data.aws_iam_policy_document.vpc_cni.json
  name               = "vpc-cni-role"
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}
*/
