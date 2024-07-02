output "flask_app_service_url" {
  value = kubernetes_service.flask_app.status[0].load_balancer[0].ingress[0].hostname
}
