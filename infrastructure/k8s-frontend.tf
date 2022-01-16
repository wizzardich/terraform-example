resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

resource "kubernetes_deployment" "express" {
  metadata {
    name      = "express-frontend"
    namespace = kubernetes_namespace.frontend.metadata.0.name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "express-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "express-frontend"
        }
      }
      spec {

        container {
          env {
            name = "HEALTH_TOKEN"
            value = "bar"
          }
          env {
            name = "FIB_ENDPOINT"
            value = "http://${kubernetes_service.backend.metadata.0.name}.${kubernetes_service.backend.metadata.0.namespace}:${kubernetes_service.backend.spec.0.port.0.port}/fib"
          }
          env {
            name = "LOAD_ENDPOINT"
            value = "http://${kubernetes_service.backend.metadata.0.name}.${kubernetes_service.backend.metadata.0.namespace}:${kubernetes_service.backend.spec.0.port.0.port}/load"
          }
          image = "express-app:latest"
          name = "express-app"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 3000
          }
          liveness_probe {
            http_get {
                path = "/health"
                port = 3000
            }
            failure_threshold = 3
            period_seconds = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "express" {
  metadata {
    name      = "express-frontend"
    namespace = kubernetes_namespace.frontend.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.express.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress_v1" "express-ingress" {
  metadata {
    name = "express-ingress"
    namespace = kubernetes_namespace.frontend.metadata.0.name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/express(/|$)(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.express.metadata.0.name
              port {
                number = kubernetes_service.express.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}