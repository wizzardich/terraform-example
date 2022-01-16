resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
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
          env {
            name = "HEALTH_TOKEN"
            value = "foo"
          }

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

resource "kubernetes_ingress_v1" "flask-ingress" {
  metadata {
    name = "flask-ingress"
    namespace = kubernetes_namespace.backend.metadata.0.name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/flask(/|$)(hello)"
          path_type = "Prefix"
          backend {
            service {
                name = kubernetes_service.backend.metadata.0.name
                
                port {
                    number = kubernetes_service.backend.spec.0.port.0.port
                }
            }
          }
        }
      }
    }
  }
}