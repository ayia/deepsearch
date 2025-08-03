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

// Fallback SearXNG instances - Updated based on searx.space reliability
const FALLBACK_INSTANCES = [
  'https://searx.bar',
  'https://searx.tiekoetter.com',
  'https://searx.prvcy.eu',
  'https://searx.be',
  'https://searx.thegpm.org'
];

export const searchSearxng = async (
  query: string,
  opts?: SearxngSearchOptions,
) => {
  let searxngURL = getSearxngApiEndpoint();
  let lastError: any = null;

  // Try the configured URL first
  try {
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

    const res = await axios.get(url.toString(), {
      timeout: 30000, // 30 second timeout
      headers: {
        'User-Agent': 'Perplexica/1.0'
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
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.warn(`SearXNG instance ${searxngURL} failed:`, errorMessage);
    lastError = error;
  }

  // Try fallback instances
  for (const fallbackURL of FALLBACK_INSTANCES) {
    try {
      const url = new URL(`${fallbackURL}/search?format=json`);
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

      const res = await axios.get(url.toString(), {
        timeout: 30000,
        headers: {
          'User-Agent': 'Perplexica/1.0'
        }
      });

      // Check if the response has the expected structure
      if (!res.data || !Array.isArray(res.data.results)) {
        console.warn(`Invalid response structure from ${fallbackURL}:`, res.data);
        throw new Error('Invalid response structure');
      }

      const results: SearxngSearchResult[] = res.data.results;
      const suggestions: string[] = res.data.suggestions || [];

      console.log(`Using fallback SearXNG instance: ${fallbackURL}`);
      return { results, suggestions };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      console.warn(`Fallback SearXNG instance ${fallbackURL} failed:`, errorMessage);
      lastError = error;
    }
  }

  // If all instances fail, return empty results
  console.error('All SearXNG instances failed:', lastError);
  return { results: [], suggestions: [] };
};
