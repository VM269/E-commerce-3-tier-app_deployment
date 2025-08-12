module kube-prom-stack {
  source  = "../modules/alb_controller"

  namespace  = "monitoring"
  repository =  "https://prometheus-community.github.io/helm-charts"

  app = {
    name          = "my-kube-prometheus-stack"
    description   = "my-kube-prometheus-stack"
    version       = "72.9.1"
    chart         = "kube-prometheus-stack"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [file("${path.module}/helm-values/kube-prom-stack.yaml")]

}
