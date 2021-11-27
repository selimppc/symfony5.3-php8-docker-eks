<?php

/**
 *  This file is part of the Symfony package.
 *
 * (c) Selim Reza <selimppc@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Controller used to manage blog contents in the public part of the site.
 * @Route("/")
 */
class DefaultController extends AbstractController
{

    /**
     * @return JsonResponse
     */
    public function index(): JsonResponse
    {
        return new JsonResponse(
            [
                'message'=> 'Hey dump, You are on kubernetes.'
            ], Response::HTTP_OK);
    }

}