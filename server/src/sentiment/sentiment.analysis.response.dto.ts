interface Confidence {
  negative: number;
  positive: number;
  neutral: number;
}

interface Sentence {
  content: string;
  offset: number;
  length: number;
  sentiment: string;
  confidence: Confidence;
  highlights: Highlight[];
}

interface Highlight {
  offset: number;
  length: number;
}

interface Document {
  sentiment: string;
  confidence: Confidence;
}

export class SentimentAnalysisResponse {
  document: Document;
  sentences: Sentence[];
}
