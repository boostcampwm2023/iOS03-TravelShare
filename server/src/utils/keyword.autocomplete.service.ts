import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { Repository } from 'typeorm';

// TODO:
// const SPECIAL_CHARACTER_REGEXP =
//   /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/g;

export class TrieNode {
  children: Map<string, TrieNode> = new Map();
  isEndOfWord: number = 0;
}

@Injectable()
export class KeywordAutoCompleteService implements OnModuleInit {
  private root: TrieNode = new TrieNode();

  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
  ) {}

  insert(word: string): void {
    let node: TrieNode = this.root;
    // word = word.replace(SPECIAL_CHARACTER_REGEXP, '');
    for (const char of word) {
      if (!node.children.has(char)) {
        node.children.set(char, new TrieNode());
      }
      node = node.children.get(char)!;
    }
    node.isEndOfWord++;
  }

  search(word: string): string[] {
    let node: TrieNode = this.root;
    for (const char of word) {
      if (!node.children.has(char)) {
        return [];
      }
      node = node.children.get(char)!;
    }
    const returnArray: any[] = [];
    this.collectWords(node, word, returnArray);
    returnArray.sort((o1, o2) => o2.score - o1.score);

    return returnArray.map(({ word }) => word).slice(0, 10);
  }

  private collectWords(node: TrieNode, word: string, returnArray: any[]) {
    // if (returnArray.length == 10) {
    //   return;
    // }
    if (node.isEndOfWord) {
      returnArray.push({ word, score: node.isEndOfWord });
    }
    for (const [char, childNode] of node.children) {
      this.collectWords(childNode, word + char, returnArray);
    }
  }

  async onModuleInit() {
    (
      await this.postRepository.find({
        select: { title: true },
      })
    )
      .map(({ title }) => title)
      .forEach((title) => this.insert(title));
  }
}
