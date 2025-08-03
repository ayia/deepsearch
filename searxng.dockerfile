FROM docker.io/searxng/searxng:latest

# Expose port
EXPOSE 8080

# Start SearXNG with default configuration
CMD ["/usr/local/bin/searxng"] 