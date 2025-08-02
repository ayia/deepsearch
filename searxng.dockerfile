FROM docker.io/searxng/searxng:latest

# Copy custom settings
COPY searxng/settings.yml /etc/searxng/settings.yml

# Expose port
EXPOSE 8080

# Start SearXNG
CMD ["/usr/local/bin/searxng"] 