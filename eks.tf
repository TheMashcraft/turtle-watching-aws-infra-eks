# Create EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.main[*].id
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_role_attachment]

  tags = {
    Name = var.cluster_name
  }
}

# Create EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.main[*].id

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_role_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.eks_registry_policy_attachment
  ]

  tags = {
    Name = "eks-node-group"
  }
}

# Create Kubernetes Deployment
resource "kubernetes_deployment" "flask_app" {
  metadata {
    name = "flask-app"
    labels = {
      app = "flask-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "flask-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }

      spec {
        container {
          image = "${var.ecr_repository}:latest"
          name  = "flask-app"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# Create Kubernetes Service
resource "kubernetes_service" "flask_app" {
  metadata {
    name = "flask-app-service"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "flask-app"
    }

    port {
      port        = 80
      target_port = 5000
    }
  }
}

# Data source for EKS cluster authentication
data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}