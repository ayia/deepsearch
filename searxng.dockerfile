FROM docker.io/searxng/searxng:latest

# Expose port
EXPOSE 8080

# Start SearXNG
CMD ["/usr/local/bin/searxng"] 