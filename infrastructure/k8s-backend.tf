resource "kubernetes_namespace" "backend" {
  metadata {
    name = "flask-backend"
  }
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "flask-backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "flask-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "flask-backend"
        }
      }
      spec {
        container {
          image = "flask-app:latest"
          name = "flask-app"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "flask-backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.flask.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 8000
      target_port = 8000
    }
  }
}