import axios from 'axios';
import { getSearxngApiEndpoint } from './config';

interface SearxngSearchOptions {
  categories?: string[];
  engines?: string[];
  language?: string;
  pageno?: number;
}

interface SearxngSearchResult {
  title: string;
  url: string;
  img_src?: string;
  thumbnail_src?: string;
  thumbnail?: string;
  content?: string;
  author?: string;
  iframe_src?: string;
}

export const searchSearxng = async (
  query: string,
  opts?: SearxngSearchOptions,
) => {
  const searxngURL = getSearxngApiEndpoint();

  const url = new URL(`${searxngURL}/search?format=json`);
  url.searchParams.append('q', query);

  if (opts) {
    Object.keys(opts).forEach((key) => {
      const value = opts[key as keyof SearxngSearchOptions];
      if (Array.isArray(value)) {
        url.searchParams.append(key, value.join(','));
        return;
      }
      url.searchParams.append(key, value as string);
    });
  }

  try {
    const res = await axios.get(url.toString(), {
      timeout: 1200000, // 20 minutes timeout - increased for SearXNG instance
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Referer': searxngURL
      }
    });

    // Check if the response has the expected structure
    if (!res.data || !Array.isArray(res.data.results)) {
      console.warn(`Invalid response structure from ${searxngURL}:`, res.data);
      throw new Error('Invalid response structure');
    }

    const results: SearxngSearchResult[] = res.data.results;
    const suggestions: string[] = res.data.suggestions || [];

    return { results, suggestions };
  } catch (error) {
    console.error(`SearXNG API error for ${searxngURL}:`, error);
    
    // Return empty results instead of throwing
    return { results: [], suggestions: [] };
  }
};
