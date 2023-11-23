export const IsRouteArray = (input: number[][]) => {
  return input.every(([x, y]) => {
    return typeof x === 'number' && typeof y === 'number';
  });
};
