{
  "framework": null,
  "installCommand": "chmod +x clone-submodules.sh && ./clone-submodules.sh && curl -fsSL -k https://fastn.com/install.sh | sh",
  "buildCommand": "bash -lc 'cd core && fastn build --base=/ && mkdir -p ../public && cp -R .build/* ../public/ && if [ -f .build/hdi/index.html ]; then cp .build/hdi/index.html ../public/index.html; fi'",
  "outputDirectory": "public",
  "redirects": [
    {
      "source": "/-/bin-it-right.fifthtry.site/hdi/:path*",
      "has": [
        { "type": "host", "value": "hdi.binitright.com" }
      ],
      "destination": "/hdi/:path*",
      "permanent": false
    }
  ],
  "rewrites": [
    {
      "source": "/:path*",
      "has": [
        { "type": "host", "value": "hdi.binitright.com" }
      ],
      "destination": "/:path*"
    }
  ]
}
