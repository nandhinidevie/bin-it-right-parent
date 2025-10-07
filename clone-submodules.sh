{
  "framework": null,
  "installCommand": "chmod +x clone-submodules.sh && ./clone-submodules.sh && curl -fsSL -k https://fastn.com/install.sh | sh",
  "buildCommand": "cd core && fastn build --base=/ && mkdir -p ../public && cp -R .build/* ../public/",
  "outputDirectory": "public",
  "redirects": [
    {
      "source": "/:file(css|js|png|jpg|jpeg|svg|webp|ico)",
      "has": [{ "type": "host", "value": "hdi.binitright.com" }],
      "destination": "/hdi/:file",
      "permanent": false
    }
  ],
  "rewrites": [
    {
      "source": "/:path*",
      "has": [{ "type": "host", "value": "hdi.binitright.com" }],
      "destination": "/hdi/:path*"
    }
  ]
}
