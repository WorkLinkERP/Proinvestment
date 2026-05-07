<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{
    private const PAGES = [
        'mission' => 'mission.html.twig',
        'services' => 'services.html.twig',
        'spaces' => 'spaces.html.twig',
        'partners' => 'partners.html.twig',
        'contact' => 'contact.html.twig',
    ];

    #[Route('/', name: 'home')]
    public function index(): Response
    {
        return $this->render('index.html.twig');
    }

    #[Route('/{path}', name: 'page')]
    public function page(string $path): Response
    {
        if (isset(self::PAGES[$path])) {
            return $this->render(self::PAGES[$path]);
        }

        throw $this->createNotFoundException();
    }
}
