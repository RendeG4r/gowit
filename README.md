# Gowit DevOps Case Study

Bu repository, Gowit DevOps Intern Case Study için geliştirdiğim çözümü içermektedir. Bu proje, basit bir Go REST API'sini containerize etmeyi, hem yerel (Minikube) hem de bulut (Google Kubernetes Engine) Kubernetes cluster'larında Helm kullanarak deploy etmeyi ve GitHub Actions ile CI/CD pipeline'ı kurmayı kapsamaktadır.

## 🚀 Kullanılan Teknolojiler

- **Go:** Basit "Hello, World!" REST API'si için
- **Docker:** Uygulamayı containerize etmek için
- **Kubernetes:** Container orchestration platformu olarak
- **Minikube:** Yerel Kubernetes geliştirme ve test için
- **Google Kubernetes Engine (GKE):** Bulut tabanlı deployment ve internet erişimi için
- **Helm:** Kubernetes üzerinde uygulamayı paketlemek ve deploy etmek için
- **GitHub Actions:** Docker imajı build ve push işlemlerini otomatize etmek için CI/CD pipeline'ı

---

## 🏗️ Proje Yapısı

```
.
├── .github/
│   └── workflows/
│       └── docker-publish.yml   # GitHub Actions CI/CD workflow'u
├── gowit-chart/                 # Uygulama için Helm chart'ı
│   ├── Chart.yaml
│   ├── templates/
│   └── values.yaml
├── Dockerfile                   # Go uygulaması için Dockerfile
├── go.mod
├── main.go                      # Go uygulaması kaynak kodu
└── README.md                    # Bu dosya
```

---

## 🐳 Adım 1: Containerize Etme

Go uygulaması, multi-stage `Dockerfile` kullanılarak containerize edilmiştir. Bu yaklaşım, build ortamını runtime ortamından ayırarak küçük ve güvenli bir final imaj sağlar.

- **Docker Hub Repository:** [rendeg4r/gowit](https://hub.docker.com/r/rendeg4r/gowit)

---

## 💻 Adım 2: Yerel Deployment (Minikube)

Uygulama, sağlanan Helm chart'ı kullanılarak yerel bir Minikube cluster'ına deploy edilebilir.

### Gereksinimler

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Deployment Adımları

1.  **Minikube'ü Başlatın:**
    ```bash
    minikube start
    ```

2.  **Helm Chart'ını Yükleyin:**
    Minikube için `gowit-chart/values.yaml` dosyasında servis tipi `NodePort` olarak ayarlanmalıdır.
    ```bash
    helm install gowit-local gowit-chart/
    ```

3.  **Uygulamaya Erişin:**
    Uygulama URL'sini almak için `minikube service` komutunu kullanın.
    ```bash
    minikube service gowit-local-gowit-chart
    ```
    Bu komut uygulamayı tarayıcınızda açacaktır.

---

## ☁️ Adım 3: Bulut Deployment (GKE)

Uygulama, GKE Autopilot cluster'ına deploy edilir ve `LoadBalancer` servisi aracılığıyla internete açılır.

### Gereksinimler

- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
- Faturalandırma etkinleştirilmiş yapılandırılmış bir Google Cloud projesi.

### Deployment Adımları

1.  **GKE Cluster'ı Oluşturun:**
    Bir GKE Autopilot cluster'ı oluşturuldu.
    ```bash
    gcloud container clusters create-auto gowit-cluster --region=europe-west1
    ```

2.  **`kubectl`'i Yapılandırın:**
    ```bash
    gcloud container clusters get-credentials gowit-cluster --region=europe-west1
    ```

3.  **Helm Chart'ını Yükleyin:**
    `gowit-chart/values.yaml` dosyasında servis tipi `LoadBalancer` olarak ayarlanmalıdır.
    ```bash
    helm install gowit-gke gowit-chart/ --namespace gowit --create-namespace
    ```

4.  **Uygulamaya Erişin:**
    LoadBalancer'ın dış IP adresini alın.
    ```bash
    kubectl get service gowit-gke-gowit-chart -n gowit
    ```
    Uygulama `http://<EXTERNAL-IP>:8080` adresinden erişilebilir. Bu proje için IP adresi `http://35.195.32.4:8080` idi.

---

## 🔄 Adım 4: GitHub Actions ile CI/CD

GitHub Actions (`.github/workflows/docker-publish.yml`) kullanılarak bir CI/CD pipeline'ı yapılandırılmıştır.

- **Tetikleyici:** `main` branch'ine yapılan her `push` işlemi.
- **İş Akışı:**
    1.  Secrets (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`) kullanarak Docker Hub'a giriş yapar.
    2.  `Dockerfile`'dan Docker imajını build eder.
    3.  Yeni imajı `latest` tag'i ile Docker Hub'a push eder (`rendeg4r/gowit:latest`).

Bu, kodun en son versiyonunun her zaman deployment için container imajı olarak mevcut olmasını sağlar.

---

## 🎯 Proje Sonuçları

Bu proje ile başarıyla tamamlanan işlemler:

✅ **Containerize Etme:** Go uygulaması Docker imajı haline getirildi ve Docker Hub'a yüklendi  
✅ **Yerel Deployment:** Minikube üzerinde başarıyla çalıştırıldı  
✅ **Bulut Deployment:** GKE üzerinde internete açık şekilde deploy edildi  
✅ **Helm Chart:** Uygulama Helm ile paketlendi ve deploy edildi  
✅ **CI/CD Pipeline:** GitHub Actions ile otomatik build ve push sistemi kuruldu  
✅ **İnternet Erişimi:** Uygulama LoadBalancer ile internete açıldı  

---

## 📞 İletişim

Bu proje hakkında sorularınız için GitHub üzerinden iletişime geçebilirsiniz. 