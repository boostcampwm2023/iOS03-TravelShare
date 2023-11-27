import * as fs from 'fs';
const rawData = fs.readFileSync('./src/utils/nicknamedata.json', 'utf-8');

const data = JSON.parse(rawData);

const prenounArray: string[] = data.prenoun;
const animalArray: string[] = data.animal;

export function getRandomNickName() {
  const prenounIdx: number =
    Math.floor(Math.random() * prenounArray.length * 7) % prenounArray.length;
  const animalIdx: number =
    Math.floor(Math.random() * animalArray.length * 7) % animalArray.length;
  const nickname: string = `${prenounArray[prenounIdx]} ${animalArray[animalIdx]}`;
  return nickname;
}
